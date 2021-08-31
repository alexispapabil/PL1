#include <stdio.h>
#include <stdlib.h>

typedef struct box box;

struct box{
	int i;
	int j;
};

struct node{
	box data;
	struct node* next;
};

struct node* front=NULL;
struct node* rear=NULL;

int added=0;
int removed=0;

box form(int i,int j){
	box new;
	new.i=i;
	new.j=j;
	return new;
}

void enqueue(box item){
	struct node *nptr=malloc(sizeof(struct node));
	nptr->data=item;
	nptr->next=NULL;
	if(front==NULL) front=nptr;
	else rear->next=nptr;
	rear=nptr;
	added++;
}

box dequeue(){
	struct node* temp=front;
	box res=front->data;
	if(front==rear) rear=NULL;
	front=front->next;
	free(temp);
	removed++;
	return res;
}

int empty(){
	return front == NULL;
}

int not_flooded(int item){
	return item == -1;
}

int not_flooded_1(int item,int t){
	return item > t;
}

int main(int argc,char **argv){
	
	int n,m,i,j,initial;
	int a[1000][1000];
	box cat;
	
	n=0;
	m=0;
	i=0;
	j=0;
  
	FILE *infile=fopen(argv[1],"r");

	if(infile<0){
		perror("fopen");
		exit(1);
	}

	while(!feof(infile)){
		char c=fgetc(infile);
		if(c=='\n'){
			n++;
			i++;
			m=j;
			j=0;
		}
		else{
			if(c!=EOF) a[i][j]=-1;
			if(c=='W') {enqueue(form(i,j)); a[i][j]=0;}
			if(c=='X') a[i][j]=-2;
			if(c=='A') cat=form(i,j);
			j++;
		}
	}
	
	box t;
	int time=1;
	initial=added;

	while(!empty()){
		t=dequeue();		
		if((t.i)-1>=0 && not_flooded(a[(t.i)-1][t.j])==1){
			enqueue(form((t.i)-1,t.j)); 
			a[(t.i)-1][t.j]=time;
		}
		if((t.i)+1<n && not_flooded(a[(t.i)+1][t.j])==1){
			enqueue(form((t.i)+1,t.j)); 
			a[(t.i)+1][t.j]=time;
		}
		if((t.j)-1>=0 && not_flooded(a[t.i][(t.j)-1])==1){
			enqueue(form(t.i,(t.j)-1)); 
			a[t.i][(t.j)-1]=time;
		}
		if((t.j)+1<m && not_flooded(a[t.i][(t.j)+1])==1){
			enqueue(form(t.i,(t.j)+1)); 
			a[t.i][(t.j)+1]=time;
		}
		if(initial==removed){
			time++; 
			added=added-initial; 
			initial=added; 
			removed=0;
		}
	}

	int move[n][m];
	for(i=0; i<n; i++)
		for(j=0; j<m; j++) move[i][j]='0';

	box safe=cat;
	enqueue(cat);
	int safetime=a[cat.i][cat.j]-1;
	time=0;
	int count=0;
	initial=added;

	while(!empty()){
		t=dequeue();
		if(a[t.i][t.j]-1>safetime){
			safe.i=t.i; 
			safe.j=t.j; 
			safetime=a[t.i][t.j]-1;
		}
		else if(a[t.i][t.j]-1==safetime){
			if(t.i<safe.i || (t.i==safe.i && t.j<safe.j)){
				safe.i=t.i; 
				safe.j=t.j; 
				safetime=a[t.i][t.j]-1;
			}
		}
		if((t.i)+1<n && move[(t.i)+1][t.j]=='0' && (not_flooded_1(a[(t.i)+1][t.j],time+1) || a[(t.i)+1][t.j]==-1)){
			enqueue(form((t.i)+1,t.j)); 
			move[(t.i)+1][t.j]='D';
			count++;
		}
		if((t.j)-1>=0 && move[t.i][(t.j)-1]=='0' && (not_flooded_1(a[t.i][(t.j)-1],time+1) || a[t.i][(t.j)-1]==-1)){
			enqueue(form(t.i,(t.j)-1));
			move[t.i][(t.j)-1]='L'; 
			count++;
		}
		if((t.j)+1<m && move[t.i][(t.j)+1]=='0' && (not_flooded_1(a[t.i][(t.j)+1],time+1) || a[t.i][(t.j)+1]==-1)){
			enqueue(form(t.i,(t.j)+1));
			move[t.i][(t.j)+1]='R';
			count++;
		}  
		if((t.i)-1>=0 && move[(t.i)-1][t.j]=='0' && (not_flooded_1(a[(t.i)-1][t.j],time+1) || a[(t.i)-1][t.j]==-1)){
			enqueue(form((t.i)-1,t.j));
			move[(t.i)-1][t.j]='U';
			count++;
		}
		if(initial==removed){
			time++;
			added=added-initial; 
			initial=added; 
			removed=0;
		}
	}

	i=0;
	t=safe;
	int cur_i,cur_j;
	char path[count];
	while(t.i!=cat.i || t.j!=cat.j){
		cur_i=t.i;
		cur_j=t.j;
		if(move[cur_i][cur_j]=='D'){
			path[i]='D'; 
			t.i=t.i-1;
			i++;
		}
		if(move[cur_i][cur_j]=='L'){
			path[i]='L'; 
			t.j=t.j+1; 
			i++;
		}
		if(move[cur_i][cur_j]=='R'){
			path[i]='R';
			t.j=t.j-1; 
			i++;
		}
		if(move[cur_i][cur_j]=='U'){
			path[i]='U'; 
			t.i=t.i+1; 
			i++;
		}
	}
	
	i--;
	if(safetime<0) printf("infinity\n");
	else printf("%d\n",safetime);
	if(i<0) printf("stay");
	while(i>=0){
		printf("%c",path[i]);
		i--;
	}
	printf("\n");
} 
