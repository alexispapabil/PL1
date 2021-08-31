import java.util.*;
public class IntTuple implements Tuple{
	private int lower,upper;
	private Tuple previous;

	public IntTuple(int l,int u){
		lower=l;
		upper=u;
	}

	@Override
	public int getLower(){
		return lower;
	}

	@Override
	public int getUpper(){
		return upper;
	}

	@Override
	public Collection<Tuple> operators(){
		Collection<Tuple> intervals=new ArrayList<>();
		intervals.add(new IntTuple(this.lower/2,this.upper/2));
		intervals.add(new IntTuple(3*this.lower+1,3*this.upper+1));
		return intervals;
	}

	@Override
	public boolean equals(Object o){
		if(this==o) return true;
		if(o==null || getClass()!=o.getClass()) return false;
		IntTuple other=(IntTuple) o;
		return (lower==other.lower && upper==other.upper);
	}

        @Override
	public int hashCode(){
		return Objects.hash(lower,upper);
	}

	@Override
	public boolean isValid(){
		return (this.upper<1000000);
	}

	@Override 
	public boolean reachedInt(Tuple t){
		return (this.lower>=t.getLower() && this.upper<=t.getUpper());
	}
}
