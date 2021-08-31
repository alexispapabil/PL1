import java.util.*;

public class TrailBlazer implements Blazer{
	@Override
	public ArrayList<String> blazer(Box cat,int r,int c,int[][] move){
		int row=r;
   		int col=c;
   		int cat_row=cat.row_pos();
   		int cat_col=cat.col_pos();
   		ArrayList<String> path=new ArrayList<String>();
		while(row!=cat_row || col!=cat_col){
			int cur_row=row;
     			int cur_col=col;
     			if(move[cur_row][cur_col]=='D'){ 
	   			path.add("D"); 
	   			row=row-1;
     			}
     			if(move[cur_row][cur_col]=='L'){
           			path.add("L");
           			col=col+1;
     			}
     			if(move[cur_row][cur_col]=='R'){
           			path.add("R");
           			col=col-1;
     			}
     			if(move[cur_row][cur_col]=='U'){
           			path.add("U");
           			row=row+1;
     			}
   		}
   		return path;
  	}
}
