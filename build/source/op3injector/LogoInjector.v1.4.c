/* 
 * Logo Injector v1.4 aka OP3Inject
 *
 * Copyright (C) 2016 Joseph Andrew Fornecker
 * makers_mark @ xda-developers.com
 * fornecker.joseph@gmail.com
 *
 * New in v1.2:
 * 
 * - Fixed out of scope crash involving image #26 in oppo find 7 logo.bin (26 IS BIG) 
 * - Multiple injection names possible after the -j parameter
 * - Injection names are now case insensitive
 * - BGR is the the default color order, instead of RGB
 * - Added more error checks
 * - Show the change in file size of original logo.bin compare to the modified logo.bin
 * - Several small changes dealing with readability
 *
 * New in v1.4:
 *
 * - Added the OnePlus 3's 4096 blocksize
 * - General cleanup
 * - Remains backwards compatible
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include "lodepng.h"

#define SWAP32(x) (( x >> 24 )&0xff) | ((x << 8)&0xff0000) | ((x >> 8)&0xff00) | ((x << 24)&0xff000000)
#define OFFSETSTART 48
#define BYTESPERPIXEL 3
#define MAXOFFSETS 28
#define SIZEOFLONGINT 4
#define TWOTOTHETEN 1024

typedef struct {

	uint8_t header[8];
	uint8_t blank[24];
	uint32_t width;
	uint32_t height;
	uint32_t lengthOfData;
	uint32_t special;
	uint32_t offsets[MAXOFFSETS];
	uint8_t name[64];
	uint8_t metaData[288];

} IMAGEHEAD;

uint16_t Copy(FILE *, IMAGEHEAD *, uint16_t , uint16_t, FILE *);
int32_t InjectNewStyle(FILE *, IMAGEHEAD *, uint16_t , uint8_t *, uint16_t, FILE *, uint32_t * );
int32_t RewriteHeaderZero( uint32_t , uint16_t,  FILE* , int32_t, uint32_t * );
uint32_t Encode(uint8_t*, uint8_t*, uint32_t);
uint32_t GetEncodedSize(uint8_t*, uint32_t);
uint32_t GetWidth(FILE*);
uint32_t GetHeight(FILE*);
uint64_t BlockIt(uint32_t);
uint16_t GetNumberOfOffsets(FILE*);
int32_t DecodeLogoBin(FILE*, IMAGEHEAD *);
int32_t ListFileDetails(FILE*);
uint8_t* Decode(FILE*, uint32_t, uint32_t, uint32_t, uint8_t*);
int32_t IsItTheNewStyle(FILE*);
IMAGEHEAD* ParseHeaders(FILE*, uint16_t);
int32_t IsItALogo(FILE*);
void PrintFileSize(uint32_t);
uint32_t GetFileSize(FILE *);

uint16_t iBlock = 512;
uint16_t badAss = 0;
int16_t rgb2bgr = 1;
uint16_t convertToPNG = 1;
const uint8_t HEADER[] = {0x53,0x50,0x4C,0x41,0x53,0x48,0x21,0x21};

int32_t IsItALogo(FILE *originalLogoBin){

	uint8_t string[9];
	uint16_t i;

	fread(string, 1, 8, originalLogoBin);

	for (i = 0 ; i < 8 ; i++){

		if (string[i] == HEADER[i]){

			continue;

		} else {

			return 0;

		}

	}

	return 1;
}

int32_t IsItTheNewStyle(FILE *originalLogoBin){

	int32_t newStyle = 0;
	int8_t j = 0;

	fread(&newStyle, 1, SIZEOFLONGINT, originalLogoBin);
	fseek(originalLogoBin, iBlock + 1, SEEK_SET);
	fread(&j, 1, 1, originalLogoBin);

	if (j == 0){

		iBlock = 4096;

	}

	if (newStyle == 0){

		return 1;

	} else {

		return 0;

	}
}

IMAGEHEAD *ParseHeaders(FILE *originalLogoBin, uint16_t numberOfOffsets){

	uint8_t i = 0;
	IMAGEHEAD *imageHeaders;

	imageHeaders = malloc(iBlock * numberOfOffsets);
	memset(imageHeaders, 0, iBlock * numberOfOffsets);
	fseek(originalLogoBin, 0, SEEK_SET);
	fread(&imageHeaders[i], 1 , iBlock, originalLogoBin);

	for ( i = 1 ; i < numberOfOffsets ; ++i ){

		fseek(originalLogoBin, imageHeaders[0].offsets[i], SEEK_SET);
		fread(&imageHeaders[i], 1 , iBlock, originalLogoBin);

	}

	return imageHeaders;
}

uint16_t GetNumberOfOffsets(FILE *originalLogoBin){

		uint16_t i = 0;
		uint32_t readAs = 0;

		fseek(originalLogoBin, OFFSETSTART, SEEK_SET);

		while(i < MAXOFFSETS){

			fread(&readAs, 1, SIZEOFLONGINT, originalLogoBin);

			if ((readAs == 0) && (i != 0)){

				break;

			} else {

				i++;

			}

		}

		return i;
}

uint8_t* Decode(FILE *originalLogoBin, uint32_t start, uint32_t length, uint32_t imageBytes, uint8_t* image){

	uint32_t decodedBytes = 0, i = 0;
	uint8_t* data; 

	fseek(originalLogoBin, start, SEEK_SET);
	data = (uint8_t*)malloc(length);

	if (fread(data, 1, length, originalLogoBin) != length) {

		fprintf(stderr, "Could not read file!!\n");
		exit(0);

	}

	while((i < length) && (decodedBytes < imageBytes)){

		memset(&image[decodedBytes], data[i], (data[i + 1]));
		decodedBytes += (uint8_t)data[i+1];
		i += 2;

		if ((i  < length) && (imageBytes - decodedBytes < (uint8_t)data[i + 1])){

			memset(&image[decodedBytes], data[i], imageBytes - decodedBytes);
			decodedBytes = imageBytes;
			fprintf(stdout, "More information was in encoding than resolution called for.\n");
			break;

		}

    }

	fprintf(stdout, "%ld decoded bytes\n\n", (long int)decodedBytes);
	free(data);

	if( rgb2bgr == 1 ){

		uint8_t old;
		i = 0;

		while( i < imageBytes){

			old = image[i];
			memset(&image[i], image[i + 2], 1);
			memset(&image[i + 2], old, 1);
			i += BYTESPERPIXEL;

		}

	}

	return image;
}

int32_t DecodeLogoBin(FILE *originalLogoBin, IMAGEHEAD *imageHeaders){

	uint32_t imageBytes, start;
	uint8_t* image;
	uint8_t name[65];
	uint16_t i , numberOfOffsets = GetNumberOfOffsets(originalLogoBin);

	for ( i = 0 ; i < numberOfOffsets ; i++ ){

		fprintf(stdout,"#%02d: Offset:%ld ", i + 1, (long int)imageHeaders[0].offsets[i]);

		if ((imageHeaders[i].width == 0) || (imageHeaders[i].height == 0)){

			fprintf(stdout, "Placeholder for %s\n", imageHeaders[i].metaData);
			continue;

		}

		fprintf(stdout, "\nHeader=%s\nWidth=%ld\nHeight=%ld\nData Length=%ld\nSpecial=%ld\nName=%s\nMetadata=%s\n",
			imageHeaders[i].header, (long int)imageHeaders[i].width, (long int)imageHeaders[i].height,
			(long int)imageHeaders[i].lengthOfData, (long int)imageHeaders[i].special, imageHeaders[i].name, imageHeaders[i].metaData);

		if (convertToPNG){

			start = imageHeaders[0].offsets[i] + iBlock;
			imageBytes = imageHeaders[i].width * (imageHeaders[i].height) * BYTESPERPIXEL;
			image = malloc(imageBytes);
			const char* ext;

			ext = strrchr((const char*)imageHeaders[i].name, '.');

			if (((ext[1] == 'p') || (ext[1] == 'P')) && 
				((ext[2] == 'n') || (ext[2] == 'N')) &&
				((ext[3] == 'g') || (ext[3] == 'G')) &&
				((ext[0] == '.'))){

				sprintf((char*)name, "%s", imageHeaders[i].name);

			} else {

				sprintf((char*)name, "%s.png", imageHeaders[i].name);

			}

			lodepng_encode24_file((const char*)name, Decode(originalLogoBin, (uint32_t)start, (uint32_t)imageHeaders[i].lengthOfData, (uint32_t)imageBytes, image) , (unsigned)imageHeaders[i].width, (unsigned)imageHeaders[i].height);
			free(image);

		}

	}

	return 0;
}

int32_t ListFileDetails(FILE *originalLogoBin){

	uint32_t i = 0;
	fseek(originalLogoBin, 0, SEEK_SET);
	uint16_t numberOfOffsets = GetNumberOfOffsets(originalLogoBin);
	IMAGEHEAD *imageHeaders = ParseHeaders(originalLogoBin, numberOfOffsets);

	fprintf(stdout, "Resolution\tOffset\t\tName\n");
	fprintf(stdout, "-------------------------------------------------------------\n");

	for ( i = 0 ; i < numberOfOffsets ; i++ ){

		if ((imageHeaders[i].width == 0) || (imageHeaders[i].height == 0)){

			fprintf(stdout, "(placeholder) for %s\n", imageHeaders[i].metaData);
			continue;

		}

		fprintf(stdout,"%dx%d\t", imageHeaders[i].width, imageHeaders[i].height);
		if ((imageHeaders[i].width < 1000) && (imageHeaders[i].height <1000)){fprintf(stdout, "\t");}
		fprintf(stdout, "%ld\t", (long int)imageHeaders[0].offsets[i]);
		if (imageHeaders[0].offsets[i] < 10000000){fprintf(stdout, "\t");}
		fprintf(stdout, "%s\n", imageHeaders[i].name );

	}

	return 1;
}

 uint16_t Copy(FILE *originalLogoBin, IMAGEHEAD *imageHeaders, uint16_t numberOfOffsets, uint16_t injectionNumber, FILE *modifiedLogoBin){

		uint8_t *data;
		uint32_t imageSize = BlockIt(iBlock + imageHeaders[injectionNumber].lengthOfData);

		if( imageHeaders[injectionNumber].name[0] == 0){

			fprintf(stdout, "Copying \t#%d:(placeholder) %s\n", injectionNumber + 1 , imageHeaders[injectionNumber].metaData);

		} else {

			fprintf(stdout, "Copying \t#%d:%s\n", injectionNumber + 1 , imageHeaders[injectionNumber].name);

		}

		data = malloc(imageSize);
		memset(data, 0 , imageSize);
		fread(data, 1, imageSize, originalLogoBin);
		fwrite(data, 1 , imageSize, modifiedLogoBin);
		free(data);

	return 1;
}

int32_t InjectNewStyle(FILE *originalLogoBin, IMAGEHEAD *imageHeaders, uint16_t numberOfOffsets, uint8_t *injectionName, uint16_t injectionNumber, FILE *modifiedLogoBin, uint32_t *ihMainOffsets ){
	
		uint32_t encodedSize = 0, actualWritten = 0;
		int8_t inFileName[69];
		int32_t blockDifference;
		FILE *pngFile;
		uint16_t op3 = 0;
		sprintf((char*)inFileName, "%s", injectionName);

		
		if (imageHeaders[injectionNumber].special != 1){

			fprintf(stdout, "ERROR: \"Special\" is not equal to '1' \nThis would not be safe to flash!\nPlease email logo.bin in question to:\nfornecker.joseph@gmail.com\n");
			fclose(originalLogoBin);
			fclose(modifiedLogoBin);
			return 0;

		}

		if ((pngFile = fopen((const char*)inFileName, "rb")) == NULL){

			sprintf((char*)inFileName, "%s.png", injectionName);

			if ((pngFile = fopen((const char*)inFileName, "rb")) == NULL){

				fclose(pngFile);
				fclose(modifiedLogoBin);
				fclose(originalLogoBin);
				fprintf(stderr, "%s could not be read\n", inFileName);
				return 0;

			}
		}

		IMAGEHEAD new;

		memset(new.blank, 0, sizeof(new.blank));
		memset(new.metaData, 0, sizeof(new.metaData));
		memset(new.offsets, 0, SIZEOFLONGINT * MAXOFFSETS);
		memset(new.name, 0, sizeof(new.name));
		strncpy((char*)new.header, (const char*)HEADER , 8);
		strncpy((char*)new.metaData, (const char*)imageHeaders[injectionNumber].metaData, sizeof(imageHeaders[injectionNumber].metaData));
		strncpy((char*)new.name, (const char*)injectionName, 64);
		new.special = 1;

		fprintf(stdout, "Injecting\t#%d:%s\n", injectionNumber + 1 , imageHeaders[injectionNumber].name);

		if (((new.width = GetWidth(pngFile)) != imageHeaders[injectionNumber].width) && (!badAss)){

			fprintf(stderr, "Error: Width of PNG to be injected is %d, it must be %d!\n", new.width, imageHeaders[injectionNumber].width);
			fclose(pngFile);
			fclose(modifiedLogoBin);
			fclose(originalLogoBin);

			return 0;

		}

		if (((new.height = GetHeight(pngFile)) != imageHeaders[injectionNumber].height) && (!badAss)){

			fprintf(stderr, "Error: Height of PNG to be injected is %d, it must be %d!\n", new.height, imageHeaders[injectionNumber].height);
			fclose(pngFile);
			fclose(modifiedLogoBin);
			fclose(originalLogoBin);

			return 0;

		}

		uint32_t rawBytes = new.width * new.height * BYTESPERPIXEL;
		uint8_t *decodedPNG = malloc(rawBytes);

		lodepng_decode24_file(&decodedPNG, (uint32_t*)&new.width, (uint32_t*)&new.height , (const char*)inFileName);

		if (rgb2bgr == 1){

			uint8_t old;
			uint32_t k = 0;

			while( k < rawBytes ){

				old = decodedPNG[k];
				memset(&decodedPNG[k], decodedPNG[k + 2], 1);
				memset(&decodedPNG[k + 2], old, 1);
				k += BYTESPERPIXEL;

			}
		}

		encodedSize = GetEncodedSize(decodedPNG, (new.width * new.height * BYTESPERPIXEL));
		new.lengthOfData = encodedSize;
		uint8_t *rlEncoded = malloc(BlockIt(encodedSize));
		memset(rlEncoded, 0, BlockIt(encodedSize));
		actualWritten = Encode(decodedPNG, rlEncoded, (new.width * new.height * BYTESPERPIXEL));
		blockDifference = (((iBlock + BlockIt(actualWritten)) - (iBlock + BlockIt(imageHeaders[injectionNumber].lengthOfData))) / iBlock);
		fwrite(&new, 1 , 512, modifiedLogoBin);

		for (op3 = 0; op3 < iBlock - 512; op3++){
			fputc(0, modifiedLogoBin);
		}

		fwrite(rlEncoded, 1 , BlockIt(actualWritten), modifiedLogoBin);
		free(decodedPNG);
		free(rlEncoded);

		RewriteHeaderZero( injectionNumber , numberOfOffsets , modifiedLogoBin , blockDifference, ihMainOffsets);

		fclose(pngFile);
		

		return 1;
}

int32_t RewriteHeaderZero( uint32_t injectionImageNumber , uint16_t numberOfOffsets, FILE *modifiedLogoBin , int32_t blockDifference, uint32_t *ihMainOffsets){

	uint8_t j = injectionImageNumber + 1 ;
	uint32_t filePosition = ftell(modifiedLogoBin);
	uint32_t offset = 0;

	for( ; j < numberOfOffsets; j++){

		fseek(modifiedLogoBin, OFFSETSTART + (SIZEOFLONGINT * j), SEEK_SET);
		offset = ihMainOffsets[j];
		offset += (blockDifference * iBlock);

		fseek(modifiedLogoBin, OFFSETSTART + (SIZEOFLONGINT * j), SEEK_SET);
		fwrite(&offset, 1 , SIZEOFLONGINT , modifiedLogoBin);
		ihMainOffsets[j] = offset;

	}

	fseek(modifiedLogoBin, filePosition , SEEK_SET);

return 1;
}

uint32_t GetEncodedSize(uint8_t* data, uint32_t size){

	uint32_t pos = 0, ret = 0;
	uint16_t count = 1;

	for( pos = 0 ; pos < size ; ++pos , count = 1){

		while((pos < size - 1) && (count < 0xFF) && ((memcmp(&data[pos], &data[pos+1], 1)) == 0)){

			count++;
			pos++;

		}

		ret += 2;

	}

	return ret;
}

uint32_t Encode(uint8_t* rawRgbReading, uint8_t* rlEncoded, uint32_t rawSize){

	uint32_t writePosition = 0 , readPosition = 0;
	uint16_t count = 1;

	for( readPosition = 0 ; readPosition < rawSize ; ++readPosition , count = 1){

		while((readPosition < rawSize - 1 ) && (count < 0xFF) && ((memcmp(&rawRgbReading[readPosition], &rawRgbReading[readPosition+1], 1)) == 0)){

			count++;
			readPosition++;

		}

		rlEncoded[writePosition] = rawRgbReading[readPosition];
		rlEncoded[writePosition + 1] = count;
		writePosition += 2;

	}

	return writePosition;
}

uint32_t GetWidth(FILE *pngFile){

	uint32_t width;

	fseek(pngFile, 16, SEEK_SET);
	fread(&width, 1, SIZEOFLONGINT, pngFile);

	return(SWAP32(width));

}

uint32_t GetHeight(FILE *pngFile){

	uint32_t height;

	fseek(pngFile, 20, SEEK_SET);
	fread(&height, 1, SIZEOFLONGINT, pngFile);

	return(SWAP32(height));
}

uint64_t BlockIt(uint32_t isize){

	uint32_t blockSize = iBlock;

	if ((isize % blockSize) == 0){

		return isize;

	}else{

		return isize + (blockSize - (isize % blockSize));

	}
}

void Usage(){

	fprintf(stdout, "Usage: OP3Inject -i \"input file\" [-l] | [-L] | [-d [-s]] | [-j \"image to be replaced\" [-b] | [-s]]\n\n");
	fprintf(stdout, "Mandatory Arguments:\n\n");
	fprintf(stdout, "\t-i \"C:\\xda\\logo.bin\"\n");
	fprintf(stdout, "\t   This is the logo.bin file to analyze or inject an image\n\n");
	fprintf(stdout, "Optional Arguments:\n\n");
	fprintf(stdout, "\t-d Decode all images into PNGs, (-s)wap parameter may be needed for proper color.\n");
	fprintf(stdout, "\t-l Lower case 'L' is to display a short list of what is inside the input file.\n");
	fprintf(stdout, "\t-L Upper case 'L' is for a more detailed list of logo.bin image contents.\n");
	fprintf(stdout, "\t-b 'b' is used to tell the program to disregard width or height differences\n");
	fprintf(stdout, "\t   when encoding an image, the program also won't fail if it can't find a name\n");
	fprintf(stdout, "\t   that can't be found on the inject list when encoding images. This switch\n");
	fprintf(stdout, "\t   also keeps modified logo bins over 16 gb, instead of deleting them.\n");
	fprintf(stdout, "\t-s 's' is used to swap RGB and BGR color order. Can be used on decoding or encoding.\n");
	fprintf(stdout, "\t   The default color order is BGR. Using the \"-s\" switch\n");
	fprintf(stdout, "\t   will result in a RGB color order. Bottom line: If you (-d)ecode the\n");
	fprintf(stdout, "\t   images (that have color) and the colors aren't right, then you should use (-s) to \n");
	fprintf(stdout, "\t   decode and inject images.\n");
	fprintf(stdout, "\t-j \"image(s) to be replaced\"\n");
	fprintf(stdout, "\t   The image(s) name to be replaced as seen in the (-l)ist\n");
	fprintf(stdout, "\t   Multiple image names may be put after \"-j\"\n");
	fprintf(stdout, "\t   The names simply need to be separated by a space. The names also are not case\n");
	fprintf(stdout, "\t   sensitive, and it doesn't matter if you put the extension at the end of the name.\n");
	fprintf(stdout, "\t   You actually only need to put the first characters of the name.\nExample:\n");
	fprintf(stdout, "\t   OP3Inject -i \"your_logo.bin\" -j FHD \n\n");
	fprintf(stdout, "\t   This will inject a PNG for every name in the logo bin that begins with \"fhd\"\n");

	return;
}

void PrintFileSize(uint32_t bytes){

	float megaBytes = 0, kiloBytes = 0;
	kiloBytes = (float)bytes / (float)TWOTOTHETEN;
	megaBytes = kiloBytes / (float)TWOTOTHETEN;
	
	if (kiloBytes < (float)TWOTOTHETEN){

		fprintf(stdout, "\t%.2f KB\n", kiloBytes);

	} else {

		fprintf(stdout, "\t%.2f MB\n", megaBytes);

	}

return;
}

uint32_t GetFileSize(FILE *temp){

	fseek(temp, 0 , SEEK_END);
	uint32_t fileSizeZ = ftell(temp);

return(fileSizeZ);
}

int32_t main(int32_t argc, char** argv){

	int32_t c;
	int16_t h, i , j , k = 0;
	FILE *originalLogoBin = NULL, *modifiedLogoBin = NULL;
	uint8_t *inputFile = NULL;
	uint8_t *injectNames[MAXOFFSETS];
	int16_t decodeAllOpt = 0;
	int16_t inject = 0;
	int16_t listFile = 0;
	uint16_t numberOfOffsets = 0, injected = 0;

	for(i = 0; i < MAXOFFSETS; i++){

		injectNames[i] = NULL;

	}

	fprintf(stdout, "__________________________________________________________-_-\n");
	fprintf(stdout, "Logo Injector v1.4\n\nWritten By Makers_Mark @ XDA-DEVELOPERS.COM\n");
	fprintf(stdout, "_____________________________________________________________\n\n");

	while ((c = getopt (argc, (char**)argv, "sSj:J:hHbBdDlLi:I:")) != -1){

		switch(c)
		{
			case 'l':

				listFile = 1;
				break;

			case 'L':

				decodeAllOpt = 1;
				convertToPNG = 0;
				break;

			case 'i':
			case 'I':

				inputFile = (uint8_t*)optarg;
				break;

			case 'b':
			case 'B':

				badAss = 1;
				break;

			case 'j':
			case 'J':

				h = optind - 1 ;
				uint8_t *nextArg;

				while(h < argc){

					inject = 1;
					nextArg = (uint8_t*)strdup(argv[h]);
					h++;

					if(nextArg[0] != '-'){

						injectNames[k++] = nextArg;

					} else {

						break;

					}
				}
				optind = h - 1;
				break;

			case 'd':
			case 'D':

				decodeAllOpt = 1 ;
				break;

			case 's':
			case 'S':

				rgb2bgr = -1 ;
				break;

			case 'h':
			case 'H':

				Usage();
				return 0;
				break;

			default:
				Usage();
				return 0;
				break;

		}
	}

	if (inputFile == NULL){

		Usage();
		return 0;

	}

	fprintf(stdout, "FILE: %s\n_____________________________________________________________\n\n", inputFile);

	if (rgb2bgr == 1){

		fprintf(stdout, "BGR is the color order. Use \"-s\" switch to change it to RGB.\n\n");

	} else {

		fprintf(stdout, "RGB is the color order. Use \"-s\" switch to change it to BGR.\n\n");

	}

	if ((originalLogoBin = fopen((const char*)inputFile, "rb")) == NULL){

		fprintf(stderr, "%s could not be opened\n", inputFile);
		return 0;

	}

	if (!IsItALogo(originalLogoBin)){

		fprintf(stdout, "\nThis is NOT a valid Logo.bin\n\n");
		fclose(originalLogoBin);
		return 0;

	}

	if (!IsItTheNewStyle(originalLogoBin)){

		fprintf(stdout, "\nThis is the old style logo.bin\n\n");
		fclose(originalLogoBin);
		return 0;

	}

	numberOfOffsets = GetNumberOfOffsets(originalLogoBin);
	IMAGEHEAD *imageHeaders = ParseHeaders(originalLogoBin, numberOfOffsets);

	if (listFile){

		ListFileDetails(originalLogoBin);
		return 1;

	}

	if(inject){

		uint32_t ihMainOffsets[MAXOFFSETS];
		uint8_t found = 0, exitFlag = 0;

		for (i = 0; i < MAXOFFSETS ; i++){

			ihMainOffsets[i] = 0;

		}

		for (j = 0; j < k ; j++){

			for (i = 0 ;  i < numberOfOffsets ; i++ ){

				if((strcasecmp((const char*)imageHeaders[i].name, (const char*)injectNames[j]) == 0) ||
				   (strncasecmp((const char*)imageHeaders[i].name, (const char*)injectNames[j], strlen((const char*)injectNames[j])) == 0)){

					found = 1;
					break;

				} else {

					found = 0;

				}
			}

			if (!found){

				fprintf(stdout, "ERROR: \"%s\" is not in the logo bin !!!!\n", injectNames[j]);
				exitFlag = 1;
			}
		}

		if ((exitFlag) && (!badAss)){

			fclose(originalLogoBin);
			exit(0);

		}

		memcpy(&ihMainOffsets , &imageHeaders[0].offsets, SIZEOFLONGINT * MAXOFFSETS);
		fseek(originalLogoBin, 0, SEEK_SET);

		if ((modifiedLogoBin = fopen("modified.logo.bin", "wb+")) == NULL){

			fclose(modifiedLogoBin);
			fclose(originalLogoBin);
			fprintf(stderr, "modified.logo.bin could not be opened\n");
			return 0;

		}

		for (i = 0 ; i < numberOfOffsets ; i++ , injected = 0 ){

			for (j = 0; j < k ; j++){

				if((strcasecmp((const char*)imageHeaders[i].name, (const char*)injectNames[j]) == 0) ||
				    (strncasecmp((const char*)imageHeaders[i].name, (const char*)injectNames[j], strlen((const char*)injectNames[j])) == 0)){

					if (InjectNewStyle(originalLogoBin, imageHeaders , numberOfOffsets, imageHeaders[i].name, i, modifiedLogoBin, ihMainOffsets) == 0){

						fprintf(stderr, "Error: Injecting %s\n", imageHeaders[i].name);
						fclose(originalLogoBin);
						fclose(modifiedLogoBin);
						return 0;

					}

					if ( i != numberOfOffsets - 1 ){

						fseek(originalLogoBin, imageHeaders[0].offsets[i+1], SEEK_SET);

					}

					injected = 1;
					break;
				}
			}

			if (!injected){

				Copy(originalLogoBin , imageHeaders, numberOfOffsets, i, modifiedLogoBin);

			}
		}

		if (GetNumberOfOffsets(modifiedLogoBin) != numberOfOffsets){

			fprintf(stderr, "ERROR: The number of offsets doesn't match the Original file!!\n");
			fclose(modifiedLogoBin);

			if (!badAss){
				
				unlink("modified.logo.bin");

			}
			
			exit(0);

		}

		fclose(modifiedLogoBin);

		fprintf(stdout, "\n\nContents of the NEW \"modified.logo.bin\":\n");
		fprintf(stdout, "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\n\n");
		FILE *newModified;
		if ((newModified = fopen("modified.logo.bin", "rb")) == NULL){

			fclose(originalLogoBin);
			fprintf(stderr, "modified.logo.bin could not be opened\n");
			return 0;

		}

		ListFileDetails(newModified);
		fprintf(stdout, "\n\n_____________________________________________________________\nOriginal filesize: ");
		PrintFileSize(GetFileSize(originalLogoBin));
		fprintf(stdout, "Modified filesize: ");
		PrintFileSize(GetFileSize(newModified));
		fprintf(stdout, "-------------------------------------------------------------\n");

		if (GetFileSize(newModified) > 0x1000000){
			fprintf(stdout, "\nTHE MODIFIED.LOGO.BIN IS LARGER THAN 16 GIGABYTES!\n");
			fprintf(stdout, "THE SPLASH PARTITION ON THE ONEPLUS 3 IS NOT BIG \n");
			fprintf(stdout, "ENOUGH TO HOLD THIS MODIFIED LOGO!\n");
			if (!badAss){
				fclose(newModified);
				unlink("modified.logo.bin");
				return 0;
			}
		}	
		fclose(originalLogoBin);
		fclose(newModified);

		return 1;
	}		

	if (decodeAllOpt){

		DecodeLogoBin(originalLogoBin, imageHeaders);
		fclose(originalLogoBin);

		return 1;
	}

	fclose(originalLogoBin);
	return 1;

}

