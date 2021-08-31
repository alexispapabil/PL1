import java.util.*;

public class BFSolver1 implements Solver1{
	@Override
	public void solve1 (Queue<Box> q,int[][] a,int n,int m){
		int time=1;
		int removed=0;
		int added=q.size();
		int initial=added;
		while(!q.isEmpty()){
			Box t=q.remove();
			removed=removed+1;
			int row=t.row_pos();
			int col=t.col_pos();
			if(row-1>=0 && a[row-1][col]==-1){
				Box temp=new Box(row-1,col);
				q.add(temp);
				added=added+1;
				a[row-1][col]=time;
			}
        		if(row+1<n && a[row+1][col]==-1){
				Box temp=new Box(row+1,col);
				q.add(temp);
				added=added+1;
				a[row+1][col]=time;
			}
        		if(col-1>=0 && a[row][col-1]==-1){
				Box temp=new Box(row,col-1);
				q.add(temp);
				added=added+1;
				a[row][col-1]=time;
			}
        		if(col+1<m && a[row][col+1]==-1){
				Box temp=new Box(row,col+1);
				q.add(temp);
				added=added+1;
				a[row][col+1]=time;
			}	
			if(initial==removed){
				time=time+1; 
				added=added-initial; 
				initial=added; 
				removed=0;
			}
		}
	}
}
