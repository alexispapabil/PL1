import java.io.*;
import java.util.*;
import java.util.Scanner;

public class Ztalloc{
    	public static void main(String args[]) throws IOException{
		File inFile=null;
		if(0<args.length) inFile=new File(args[0]);
		else return;
		Scanner scan=new Scanner(inFile);
		int n,lin,rin,lout,rout;
		n=scan.nextInt();
                Hashtable<Tuple,Tuple> sofar=new Hashtable<>();
		for(int i=0; i<n; i++){
			lin=scan.nextInt();
			rin=scan.nextInt();
			lout=scan.nextInt();
			rout=scan.nextInt();
			Tuple start=new IntTuple(lin,rin);
			Tuple end=new IntTuple(lout,rout);
			String path=new String();
			Finder bfs=new BFS();
			path=bfs.find(start,end,sofar);
			System.out.print(path);
			System.out.print('\n');
                        sofar.clear();
		}
	}

}
