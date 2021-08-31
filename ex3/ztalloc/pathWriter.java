import java.util.*;

public class pathWriter implements Form{
	@Override
	public String pathForm(Tuple start,Tuple t,Hashtable<Tuple,Tuple> sofar){
		Tuple temp=t;
		if(temp.equals(start)) return "EMPTY";
		String path=new String();
		Tuple cur=sofar.get(temp);
		while(!cur.equals(start)){
			if(temp.getLower()>cur.getLower()) path="t"+path;
			else path="h"+path;
			temp=cur;
			cur=sofar.get(temp);
		}
		if(temp.getLower()>cur.getLower()) path="t"+path;
		else path="h"+path;
		return path;
	}
}
