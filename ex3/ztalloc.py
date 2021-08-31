#!/usr/bin/env python3

from collections import deque
q=deque()
s=set()
sofar=dict()

def halve(state):
    lower=state[0]//2
    upper=state[1]//2
    return (lower,upper) 

def triple_plus_one(state):
    lower=3*state[0]+1
    upper=3*state[1]+1
    return (lower,upper)

def inlimit(state):
    return (state[0]<1000000 and state[1]<1000000)

def form_path(sofar,Lin,Rin,t):
    temp=t
    start=(Lin,Rin)
    if(temp==start): 
        return "EMPTY";
    path=""
    cur=sofar.get(temp)
    while(cur!=start):
        if(temp[0]>cur[0]):
            path="t"+path
        else:
            path="h"+path
        temp=cur
        cur=sofar.get(temp)
    if(temp[0]>cur[0]): 
        path="t"+path;
    else:
        path="h"+path
    return path

def bfs(Lin,Rin,Lout,Rout):
    s.clear()
    q.clear()
    sofar.clear()
    s.add((Lin,Rin))
    q.append((Lin,Rin))
    while(len(q)!=0):
        t=q.popleft()
        if(t[0]>=Lout and t[1]<=Rout):
            path=form_path(sofar,Lin,Rin,t)
            return path
        h=halve(t)
        if(h not in s):
            s.add(h)
            q.append(h)
            sofar.update({h:t})
        tr=triple_plus_one(t)
        if(tr not in s and inlimit(tr)):
            s.add(tr)
            q.append(tr)
            sofar.update({tr:t})
    return("IMPOSSIBLE")

def ztalloc(f):
    N=f.readline()
    for i in range(int(N)):
        Lin, Rin, Lout, Rout = map(int, f.readline().split())
        path=bfs(Lin,Rin,Lout,Rout)
        print(path)

if __name__ == "__main__":
 import sys
 if len(sys.argv) > 1:
  with open(sys.argv[1], "rt") as f:
   ztalloc(f)
 else:
  ztalloc(sys.stdin)

