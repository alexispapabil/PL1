#!/usr/bin/env python3

from collections import deque
q=deque()

def savethecat(f):
    c=list(map(str, f.read().split()))
    colm_len=len(c[0])
    line_len=len(c)
    a=[]
    index=0
    for i in range(line_len):
        for j in range(colm_len):
            if(c[i][j]=='A'):
                a.append(-1)
                cat=index
            if(c[i][j]=='W'):
                a.append(0)
                q.append(index)
            if(c[i][j]=='.'):
                a.append(-1)
            if(c[i][j]=='X'):
                a.append(-2)
            index=index+1
    
    added=len(q)
    initial=added
    removed=0
    time=1
    
    while(len(q)!=0):
        t=q.popleft()
        removed=removed+1  
        if(t-colm_len>=0 and a[t-colm_len]==-1):
            q.append(t-colm_len)
            a[t-colm_len]=time
        if(t+colm_len<len(a) and a[t+colm_len]==-1):
            q.append(t+colm_len)
            a[t+colm_len]=time
        if(t-1>=0 and (t-1)%colm_len!=colm_len-1 and a[t-1]==-1):
            q.append(t-1)
            a[t-1]=time
        if(t+1<len(a) and (t+1)%colm_len!=0 and a[t+1]==-1):
            q.append(t+1)
            a[t+1]=time
        if(initial==removed):
            time=time+1
            added=len(q)
            initial=added
            removed=0
    
    move=[]
    for i in range(len(a)):
        move.append('0')
    safe=cat
    q.append(cat)
    safetime=a[cat]-1
    time=0
    count=0
    removed=0
    added=len(q)
    initial=added
    
    while(len(q)!=0):
        t=q.popleft()
        removed=removed+1
        if(a[t]-1>safetime):
            safe=t
            safetime=a[t]-1
        elif(a[t]-1==safetime):
            if(t//colm_len<safe//colm_len or (t//colm_len==safe//colm_len and t%colm_len<safe%colm_len)):
                safe=t
                safetime=a[t]-1
        if(t+colm_len<len(a) and move[t+colm_len]=='0' and (a[t+colm_len]>time+1 or a[t+colm_len]==-1)):
            q.append(t+colm_len)
            move[t+colm_len]='D'
            count=count+1
        if(t-1>=0 and (t-1)%colm_len!=colm_len-1 and move[t-1]=='0' and (a[t-1]>time+1 or a[t-1]==-1)):
            q.append(t-1)
            move[t-1]='L'
            count=count+1
        if(t+1<len(a) and (t+1)%colm_len!=0 and move[t+1]=='0' and (a[t+1]>time+1 or a[t+1]==-1)):
            q.append(t+1)
            move[t+1]='R'
            count=count+1
        if(t-colm_len>=0 and move[t-colm_len]=='0' and (a[t-colm_len]>time+1 or a[t-colm_len]==-1)):
            q.append(t-colm_len)
            move[t-colm_len]='U'
            count=count+1
        if(initial==removed):
            time=time+1
            added=len(q)
            initial=added
            removed=0
    
    i=0
    t=safe
    path=[]
    
    while(t!=cat):
        cur=t
        if(move[cur]=='D'):
            path.append('D') 
            t=t-colm_len; 
            i=i+1
        if(move[cur]=='L'): 
            path.append('L')
            t=t+1
            i=i+1
        if(move[cur]=='R'): 
            path.append('R')
            t=t-1
            i=i+1
        if(move[cur]=='U'): 
            path.append('U')
            t=t+colm_len;  
            i=i+1
    
    i=i-1
    if(safetime<0):
        print('infinity')
    else:
        print(safetime)
    if(i<0):
        print('stay',end="")
    while(i>=0):
        print(path[i],end="")
        i=i-1
    print()
    
if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        with open(sys.argv[1], "rt") as f:
            savethecat(f)
    else:
        savethecat(sys.stdin)
