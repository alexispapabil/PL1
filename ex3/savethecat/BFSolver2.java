import java.util.*;

public class BFSolver2 implements Solver2{
	@Override
	public int[] solve2 (Queue<Box> q,Box safe,int[][] a,int[][] move,int n,int m,int safetime){
		int time=0;
		int added=q.size();
    		int initial=added;
    		int count=0;
    		int removed=0;
    		int safe_row=safe.row_pos();
    		int safe_col=safe.col_pos();
   		while(!q.isEmpty()){
			Box t=q.remove();
      			removed=removed+1;
      			int row=t.row_pos();
      			int col=t.col_pos();
      			if(a[row][col]-1>safetime){
				safe_row=row;
	 			safe_col=col;
	 			safetime=a[row][col]-1;
      			}
			else if(a[row][col]-1==safetime){
				if(row<safe_row || (row==safe_row && col<safe_col)){
					safe_row=row;
					safe_col=col;
					safetime=a[row][col]-1;
				}
			}
			if(row+1<n && move[row+1][col]=='0' && (a[row+1][col]>time+1 || a[row+1][col]==-1)){
				Box temp=new Box(row+1,col);
	  			q.add(temp);
	  			added=added+1;
	  			move[row+1][col]='D';
	  			count=count+1;
      			}
      			if(col-1>=0 && move[row][col-1]=='0' && (a[row][col-1]>time+1 || a[row][col-1]==-1)){
          			Box temp=new Box(row,col-1);
          			q.add(temp);
	  			added=added+1;
          			move[row][col-1]='L';
          			count=count+1;
      			}
      			if(col+1<m && move[row][col+1]=='0' && (a[row][col+1]>time+1 || a[row][col+1]==-1)){
          			Box temp=new Box(row,col+1);
          			q.add(temp);
	  			added=added+1;
          			move[row][col+1]='R';
          			count=count+1;
      			}
      			if(row-1>=0 && move[row-1][col]=='0' && (a[row-1][col]>time+1 || a[row-1][col]==-1)){
          			Box temp=new Box(row-1,col);
          			q.add(temp);
	  			added=added+1;
          			move[row-1][col]='U';
          			count=count+1;
      			}
      			if(initial==removed){
	      			time=time+1; 
	      			added=added-initial; 
	      			initial=added; 
	      			removed=0;
			}
		}
    		int[] arr=new int[3];
    		arr[0]=safetime;
    		arr[1]=safe_row;
    		arr[2]=safe_col;
		return arr;
  	}
}
