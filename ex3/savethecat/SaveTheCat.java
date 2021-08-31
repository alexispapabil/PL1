import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

public class SaveTheCat{
	public static void main(String args[]){
		File inFile=null;
		int[][] a=new int[1000][1000];
		Box cat=null;
		int n,m,i,j;
		n=0;
		m=0;
		i=0;
		j=0;
		if(0<args.length)inFile= new File(args[0]);
		else return;
		
		try{
			FileInputStream f=new FileInputStream(inFile);
 			char c;
     			Queue<Box> q=new ArrayDeque<>();
     			while(f.available()>0){
				c=(char) f.read();
      				if(c=='\n'){
					n=n+1;
					i=i+1;
					m=j;
					j=0;
      				}
				else{
					if(c=='X') a[i][j]=-2;
					else if(c=='W'){
						a[i][j]=0;
	 					Box t=new Box(i,j);
	 					q.add(t);
       					}
					else{
						if(c=='A') cat=new Box(i,j);
						a[i][j]=-1;
					}
					j=j+1;
				}
			}
			Solver1 solver1=new BFSolver1();
     			solver1.solve1(q,a,n,m);
     			int[][] move=new int[n][m];
     			for(i=0; i<n; i++)
       				for(j=0; j<m; j++) move[i][j]='0';
     			q.add(cat);
     			int cat_row=cat.row_pos();
     			int cat_col=cat.col_pos();
     			int safetime=a[cat_row][cat_col]-1;
     			Solver2 solver2=new BFSolver2();
     			int[] temp=new int[3];
     			temp=solver2.solve2(q,cat,a,move,n,m,safetime);
     			Blazer bl=new TrailBlazer();
     			ArrayList<String> path=new ArrayList<String>();
     			path=bl.blazer(cat,temp[1],temp[2],move);
			if(temp[0]<0) System.out.print("infinity\n");
			else{
				System.out.print(temp[0]);
	  			System.out.print('\n');
     			}
			if(path.size()==0) System.out.print("stay");
			else for(i=path.size()-1; i>=0; i--) System.out.print(path.get(i));
			System.out.print('\n');
		}
		catch(IOException e){
			e.printStackTrace();
		}
	}
}
