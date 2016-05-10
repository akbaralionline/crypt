//gcc crypt.m -o crypt `gnustep-config --objc-flags` `gnustep-config --base-libs`
/*Basic AES alike Encryption 8bit All ASCII characters including the printable, extended and control characters*/
/*The Basic execution procedure is "crypt -option hexakey source target"
where 	crypt is the binary file or executable
		option -e for encryption and -d for decryption
		hexakey is the userdefined encryption or decryption key
		source is the source file
		target is the target file
*/

# include <stdio.h>
# include <string.h>

	int datamap[16][16];
	int keymap[16][16];
	int tempmap[16];

	/* method Initialize DataMaps and KeyMaps */
	void Initialize_Datamap()
	{
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
	int KeytoDecimal(char c)
	{
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
		return t;
	}

	/* method Shift Horizontal Top */
	int HorizontalShiftTop(int t)
	{
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
	int HorizontalShiftBottom(int t)
	{
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
	int VerticalShiftRight(int t)
	{
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
	int VerticalShiftLeft(int t)
	{
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


int main (int argc, char *argv[])
{
	int st=0;
	if( argc == 5 )
	{
		printf("Preparing to process file %s\n", argv[3]);
	}
	else if( argc > 5 )
	{
		printf("Too many arguments supplied. use -h for help.\n");
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
			printf("Crypt: A command line encryption decryption tool similar to AES encryption declaration.\n");
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
			printf("Crypt Key:\n");
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
				printf("Crypt Key:\n");
				printf("Crypt uses Hexacode key for the encryption and decryption. User need to generate the key and the recommended ");
				printf("minimum recommended size is 8 digit eg 2A5B6C7D. As long as the size of the key increases the data will be more secured. ");
				printf("The hexa decimal values ranges from 0-9 and A-F. Crypt will not accept any other character apart from hexadecimal values.\n");
				return -1;
			}	
		}
	}
	else
	{
		printf("One or more argument expected. use -h for help.\n");
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
	
	
	int i,j,t;
	int key_v[32];
	printf("Preparing DataMap\n");
	Initialize_Datamap();
	printf("Preparing KeyMap\n");
	for(i=0;i<strlen(key);i++)
	{
		t=i%4;
		key_v[i]=KeytoDecimal(key[i]);
		if((key_v[i]<0)&&(key_v[i]>255))
		{
			printf("Insufficient security key Kindly use -k for help\n");
			return -1;
		}
		if(t==0)
		{
			HorizontalShiftTop(key_v[i]);
		}
		else if(t==1)
		{
			HorizontalShiftBottom(key_v[i]);
		}
		else if(t==2)
		{
			VerticalShiftLeft(key_v[i]);
		}
		else if(t==3)
		{
			VerticalShiftRight(key_v[i]);
		}
		else
		{
			printf("Invalid Key Kindly use -k for help\n");
			return -1;
		}
	}
	
	printf("DataMap and KeyMap are Created for the key %s\n",key);
	
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
		printf("Failed reading file %s\n",source);
		return -1;
	}
	
	FILE *ft = fopen(target,"wb"); 
	unsigned char c;
	
	if(strcmp(argv[1],"-e")==0)
	{
		/*Start Encryption*/
		printf("Preparing for Encryption Process\n");
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
		fprintf(ft,"\n");	
		*/
		//while((c = fgetc(fs)) != EOF)
		printf("Processing Encryption\n");
		while (!feof(fs))  
		{
			c = fgetc(fs);
			t=c;
			for(i=0;i<16;i++)
			{	
				if(datamap[t/16][i]==t)
				{
					printf("*");
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
		printf("Preparing for Decryption Process\n");
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
			printf("%d=%d\t",t,key_v[k]);
			if(t!=key_v[k])
			{
				NSLog(@"Invalid Key Kindly verify the key before retry");
				return 0;	
			}	
		}
		t=fscanf(fs," %d ",&t);
		*/
		t=0;
		printf("Processing Decryption\n");
		while(fscanf(fs," %d ",&t)==1)
		{
			int br=0;
			for(i=0;i<16;i++)
			{	
				for(j=0;j<16;j++)
				{
					if(keymap[i][j]==t)
					{
						printf("*");
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
		printf("Invalid Arguement passed use -h for help\n");
		fclose(fs);
		fclose(ft);
		return -1;
	}
		
	fclose(ft);
	fclose(fs);
	return 0;
}
