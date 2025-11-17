//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", 	 "sb-music", 0, 18},
	{"", 	 "sb-volume", 0, 10},
	{"", 	 "sb-date", 60, 24},
	{"",	 "sb-battery" , 5, 23},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = "";
static unsigned int delimLen = 0;
