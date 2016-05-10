<script>

	var datamap = [][];
	var keymap = [][]; 
	var tempmap[];
	var key[],charkey[];

// Converts an integer (Unicode value) to a char
	function IntegertoAscii(i){ 
   	return String.fromCharCode(i);
	}


// Converts a char into to an integer (Unicode value)
	function AsciitoInteger(a){ 
   	return a.charCodeAt();
	}

//Initialize data and key map
	function Initialize_Datamap(){
		var i.j,k;
		for (i=0,k=0;i<16;i++) {
			for (j=0;j<16;j++) {
				datamap[i][j]=k;
				keymap[i][j]=k;
				k++;
			}
		}
		return 0;	
	}   

// Generate Key   
	function KeyGenerator() {
		var x =16;
		while(x>=16)
    	x= Math.floor((Math.random() * 100));
    	return x
	}
	
//Horizontal Shift Top
	function HorizontalShiftTop: (int t){
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

//Horizontal Shift Bottom
	function HorizontalShiftBottom: (int t){
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
	
//Vertical Shift Right
	function VerticalShiftRight: (int)t{
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

//Vertical Shift Left
	function VerticalShiftLeft: (int t){
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
	
//Key Processor
	function KeyProcessor() {
		int i,j;
		
		for(i=0;i<16;i++){
			int t=i%4;
			if((key[i]<0)&&(key[i]>255))
			{
				return false;
			}
			if(t==0)
			{
				HorizontalShiftTop(key[i]);
			}
			else if(t==1)
			{
				HorizontalShiftBottom(key[i]);
			}
			else if(t==2)
			{
				VerticalShiftLeft(key[i]);
			}
			else
			{	
				VerticalShiftRight(key[i]);
			}
		}
	}
	
	function Encrytp(var rawdata) {
		var res = str.split("");
		var digit[];
		for (i=0;i<16;i++) {
			key[i]=KeyGenerator();
			charkey[i]=IntegertoAscii(key[i]);
		}
		KeyProcessor();
		for (var i = 0; i < res.length; i++) {
			digit = AsciitoInteger(res[i]);
			for(var j=0;j<16;j++)
			{	
				if(datamap[t/16][j]==digit)
				{
					t=keymap[t/16][j];
					res[i]=IntegertoAscii(t);
					j=16;
				}
			}					
		}
		res.join();
		charkey.join();
		rawdata = charkey.concat(res);
		return rawdata;	
	}
	
	function Decrytp(var rawdata) {
		var res = str.split("");
		var digit[];
		for (var i = 0; i < res.length; i++) {
			digit = AsciitoInteger(res[i]);
			if (i<16) {
				key[i]=digit;
				if (i==15) {
					KeyProcessor();
				}
			}
			else {
				for(var k=0;k<16;k++)
				{	
					for(j=0;j<16;j++)
					{
						if(keymap[k][j]==digit)
						{
							res[i]=AsciiToInteger(datamap[k][j]);
							
							k=16;
							j=16;
						}
					}
				}				
			}						
		}
		res.join();
		return res;	
	}
</script>
