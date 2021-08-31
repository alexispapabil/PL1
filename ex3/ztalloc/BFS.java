import java.util.*;

public class BFS implements Finder{
	@Override
	public String find(Tuple start,Tuple end,Hashtable <Tuple,Tuple> sofar){
		Set<Tuple> seen=new HashSet<>();
		Queue<Tuple> q=new ArrayDeque<>();
		seen.add(start);
		q.add(start);
		while(!q.isEmpty()){
			Tuple t=q.remove();
			if(t.reachedInt(end)){
                           Form path=new pathWriter();      
			   return path.pathForm(start,t,sofar);
			}
			for(Tuple interval : t.operators()){
				if(!seen.contains(interval) && interval.isValid()){
					q.add(interval);
					seen.add(interval);
					sofar.put(interval,t);
				}
			}
		}
		return "IMPOSSIBLE";
	}
}
