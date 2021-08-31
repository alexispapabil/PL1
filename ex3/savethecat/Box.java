public class Box{
	private int i,j;
	public Box(int row_ind,int col_ind){
		i=row_ind;
    		j=col_ind;
  	} 
	public int row_pos(){
		return i;
  	} 
	public int col_pos(){
		return j;
	}
}
