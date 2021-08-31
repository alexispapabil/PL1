#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main(int argc,char **argv){
	
	int n,k,i,start,end,arr_length;
 	bool all_elements=false;
	FILE *infile;
 	infile=fopen(argv[1],"r");
	if(infile<0){
		perror("fopen");
		exit(1);
	}
 
	if(fscanf(infile,"%d",&n));
	if(fscanf(infile,"%d",&k));
	int colours[n],visited[k];
	for(i=0; i<n; i++) if(fscanf(infile,"%d",&colours[i]));

	start=0;
	end=0;
	arr_length=n;
	for(i=0; i<k; i++) visited[i]=0;
	int counter=0;

	while(end<n && arr_length>k){ 
		if(!all_elements){
			if(visited[colours[end]-1]==0) counter++;
			visited[colours[end]-1]++;
		}
		if(counter==k){
			all_elements=true;
			if(arr_length>end-start+1) arr_length=end-start+1;
			visited[colours[start]-1]--;
			if(visited[colours[start]-1]==0){
				counter--; 
				all_elements=false;
			}
			start++;
		}
		else{
			end++;
			all_elements=false;
		}
	}
	if(!all_elements && start==0) arr_length=0;
	printf("%d\n",arr_length);
}
