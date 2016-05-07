//gcc crypt.m -o crypt `gnustep-config --objc-flags` `gnustep-config --base-libs`
/*Basic AES alike Encryption 8bit All ASCII characters including the printable, extended and control characters*/
/*The Basic execution procedure is "crypt -option hexakey source target"
where 	crypt is the binary file or executable
		option -e for encryption and -d for decryption
		hexakey is the userdefined encryption or decryption key
		source is the source file
		target is the target file
*/
#import <objc/objc.h>
#import <objc/Object.h>
#import <Foundation/Foundation.h>

	int datamap[16][16];
	int keymap[16][16];
	int tempmap[16];

@interface MapClass:NSObject
{
	
}
	/* methods declaration */
	- (void)Initialize_Datamap;
	- (int)KeytoDecimal: (char)c;
	- (int)HorizontalShiftTop: (int)t;
	- (int)HorizontalShiftBottom: (int)t;
	- (int)VerticalShiftRight: (int)t;
	- (int)VerticalShiftLeft: (int)t;
@end

@implementation MapClass
	/* method Initialize DataMaps and KeyMaps */
	- (void)Initialize_Datamap{
		int i,j,k;
		for(i=0,k=0;i<16;i++)
		{
			for(j=0;j<16;j++)
			{
				datamap[i][j]=k;
				keymap[i][j]=k;
				k++;	
			}
		}
	}

	/* method Convert Key to Decimal */
	- (int)KeytoDecimal: (char)c{
		int t;
		t=c;
		if((t>=48)&&(t<=57))
			t-=48;
		else if((t>=65)&&(t<=90))
			t-=55;
		else if((t>=97)&&(t<=122))
			t-=87;
		else
			return -1;
		//NSLog(@"%c=%d",c,t);
		return t;
	}

	/* method Shift Horizontal Top */
	- (int)HorizontalShiftTop: (int)t{
		int i,j;
		for(i=0;i<16;i++)
			tempmap[i]=0;
		for(i=0;i<16;i++)
			tempmap[i]=keymap[t][i];
		for(i=t;i>=0;i--)
		{
			for(j=0;j<16;j++)
			{
				keymap[i][j]=keymap[i-1][j];
			}
		}
		for(i=0;i<16;i++)
			keymap[0][i]=tempmap[i];
		return 0;
	}

	/* method Shift Horizontal Bottom */
	- (int)HorizontalShiftBottom: (int)t{
		int i,j;
		for(i=0;i<16;i++)
			tempmap[i]=0;
		for(i=0;i<16;i++)
			tempmap[i]=keymap[t][i];
	
		for(i=t;i<16;i++)
		{
			for(j=0;j<16;j++)
			{
				keymap[i][j]=keymap[i+1][j];
			}
		}
		for(i=0;i<16;i++)
			keymap[15][i]=tempmap[i];
		return 0;
	}

	/* method Shift Vertical Right */
	- (int)VerticalShiftRight: (int)t{
		int i,j;
		for(i=0;i<16;i++)
			tempmap[i]=0;
		for(i=0;i<16;i++)
			tempmap[i]=keymap[i][t];
		for(i=t;i<16;i++)
		{
			for(j=0;j<16;j++)
			{
				keymap[j][i]=keymap[j][i+1];
			}
		}
		for(i=0;i<16;i++)
			keymap[i][15]=tempmap[i];
		return 0;
	}

	/* method Shift Vertical Left */
	- (int)VerticalShiftLeft: (int)t{
		int i,j;
		for(i=0;i<16;i++)
			tempmap[i]=0;
		for(i=0;i<16;i++)
			tempmap[i]=keymap[i][t];
		for(i=t;i>=0;i--)
		{
			for(j=0;j<16;j++)
			{
				keymap[j][i]=keymap[j][i-1];
			}
		}
		for(i=0;i<16;i++)
			keymap[i][0]=tempmap[i];
		return 0;	
	}
@end



int main (int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"%d",argc);
	int st=0;
	if( argc == 5 )
	{
		NSLog(@"Preparing to process file %s\n", argv[3]);
	}
	else if( argc > 5 )
	{
		NSLog(@"Too many arguments supplied. use -h for help.\n");
		printf("Syntax: \tcrypt -option hexakey source target\n");
		printf("Option:\n \t-e for encryption and -d for decryption\n");
		printf("\thexakey is the userdefined encryption and decryption key\n");
		printf("\tsource is the source file\n");
		printf("\ttarget is the target file\n");
		return -1;
	}
	else if(argc==2) 
	{
	

    	if(strcmp(argv[1],"-h")==0)
		{
			NSLog(@"Crypt: A command line encryption decryption tool similar to AES encryption declaration.\n");
			printf("Crypt uses Hexacode key for the encryption and decryption. User need to generate the key and the recommended ");	
			printf("minimum size is 8 digit eg 2A5B6C7D. As long as the size of the key increases the data will be more secured.\n");
			printf("Syntax: \tcrypt -option hexakey source target\n");
			printf("Option:\n \t-e for encryption and -d for decryption\n");
			printf("\thexakey is the userdefined encryption and decryption key\n");
			printf("\tsource is the source file\n");
			printf("\ttarget is the target file\n");
			return 0;
		}
		else if(strcmp(argv[1],"-k")==0)
		{
			NSLog(@"Crypt Key:\n");
			printf("Crypt uses Hexacode key for the encryption and decryption. User need to generate the key and the recommended ");
			printf("minimum size is 8 digit eg 2A5B6C7D. As long as the size of the key increases the data will be more secured. ");
			printf("The hexa decimal values ranges from 0-9 and A-F. Crypt will not accept any other character apart from hexadecimal values.\n");
			printf("Syntax: \tcrypt -option hexakey source target\n");
			printf("Option:\n \t-e for encryption and -d for decryption\n");
			printf("\thexakey is the userdefined encryption and decryption key\n");
			printf("\tsource is the source file\n");
			printf("\ttarget is the target file\n");
			return 0;
		}
		else if(strcmp(argv[1],"-m")==0)
		{
			if(strlen(argv[2])>0)
				st=1;
			else
			{
				NSLog(@"Crypt Key:\n");
				printf("Crypt uses Hexacode key for the encryption and decryption. User need to generate the key and the recommended ");
				printf("minimum recommended size is 8 digit eg 2A5B6C7D. As long as the size of the key increases the data will be more secured. ");
				printf("The hexa decimal values ranges from 0-9 and A-F. Crypt will not accept any other character apart from hexadecimal values.\n");
				return -1;
			}	
		}
	}
	else
	{
		NSLog(@"One or more argument expected. use -h for help.\n");
		printf("Syntax: crypt -option hexakey source target\n");
		printf("Option:\n \t-e for encryption and -d for decryption\n");
		printf("\thexakey is the userdefined encryption and decryption key\n");
		printf("\tsource is the source file\n");
		printf("\ttarget is the target file\n");
		return -1;
	}
		
	char *source,*key,*target;
	
	key=argv[2];
	
	/* Preparing DataMap*/
	
	MapClass *mapClass = [[MapClass alloc]init];
	
	int i,j,t;
	int key_v[32];
	NSLog(@"Preparing DataMap");
	[mapClass Initialize_Datamap];
	NSLog(@"Preparing KeyMap");
	for(i=0;i<strlen(key);i++)
	{
		t=i%4;
		key_v[i]=[mapClass KeytoDecimal:key[i]];
		if((key_v[i]<0)&&(key_v[i]>255))
		{
			NSLog(@"Insufficient security key Kindly use -k for help");
			return -1;
		}
		if(t==0)
		{
			[mapClass HorizontalShiftTop:key_v[i]];
		}
		else if(t==1)
		{
			[mapClass HorizontalShiftBottom:key_v[i]];
		}
		else if(t==2)
		{
			[mapClass VerticalShiftLeft:key_v[i]];
		}
		else if(t==3)
		{
			[mapClass VerticalShiftRight:key_v[i]];
		}
		else
		{
			NSLog(@"Invalid Key Kindly use -k for help");
			return -1;
		}
	}
	
	NSLog(@"DataMap and KeyMap are Created for the key %s",key);
	
	/*Show Table*/
	if(st==1)
	{
		for(i=0;i<16;i++)
		{
			for(j=0;j<16;j++)
				printf(" %d ",keymap[i][j]);
			printf("\n");
		}
		return 0;	
	}
	else
	{
		source=argv[3];
		target=argv[4];
	}
	
	/*Verify and Validate File Access*/
	FILE *fs = fopen(source,"rb"); 
	if(fs==NULL)
	{
		NSLog(@"Failed reading file %s",source);
		return -1;
	}
	
	FILE *ft = fopen(target,"wb"); 
	unsigned char c;
	
	if(strcmp(argv[1],"-e")==0)
	{
		/*Start Encryption*/
		NSLog(@"Preparing for Encryption Process");
		/*
		for(i=0;i<strlen(key);i++)
		{
			for(j=0;j<16;j++)
			{	
				if(datamap[t/16][j]==key_v[i])
				{
					t=keymap[t/16][j];
					c=t;
					fprintf(ft, "%d ",t);
					break;
				}
				
			}
		}
		*/
		//while((c = fgetc(fs)) != EOF)
		while (!feof(fs))  
		{
			c = fgetc(fs);
			t=c;
			for(i=0;i<16;i++)
			{	
				if(datamap[t/16][i]==t)
				{
					t=keymap[t/16][i];
					c=t;
					fprintf(ft, "%d ",t);
					break;
				}
				
			}
		}
	}
	else if(strcmp(argv[1],"-d")==0)
	{
		/*Start Decryption*/
		NSLog(@"Preparing for Decryption Process");
		/*
		int k;
		for(k=0;k<strlen(key);k++)
		{
			while(fscanf(fs," %d ",&t)==0);
			int br=0;
			for(i=0;i<16;i++)
			{	
				for(j=0;j<16;j++)
				{
					if(keymap[i][j]==t)
					{
						t=datamap[i][j];
						c=t;
						//fputc(c,ft);
						br=1;
					}
					if(br==1)
						break;
				}
				if(br==1)
					break;
			}
			if(t!=key_v[k])
			{
				NSLog(@"Invalid Key Kindly verify the key before retry");
				return 0;	
			}
			
		}
		*/
		t=0;
		while(fscanf(fs," %d ",&t)==1)
		{
			int br=0;
			for(i=0;i<16;i++)
			{	
				for(j=0;j<16;j++)
				{
					if(keymap[i][j]==t)
					{
						t=datamap[i][j];
						c=t;
						fputc(c,ft);
						br=1;
					}
					if(br==1)
						break;
				}
				if(br==1)
					break;
			}
		}
	}
	else 
	{
		NSLog(@"Invalid Arguement passed use -h for help");
		fclose(fs);
		fclose(ft);
		return -1;
	}
		
	fclose(ft);
	fclose(fs);
	NSLog(@"Process Completed");
	[mapClass release];
    	[pool drain];
	return 0;
}
