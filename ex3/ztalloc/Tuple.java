import java.util.*;
public interface Tuple{
	public int getLower();
	public int getUpper();
	public Collection<Tuple> operators();
	public boolean equals(Object o);
	public int hashCode();
	public boolean isValid();
	public boolean reachedInt(Tuple t);
}
