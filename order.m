function p=order(K)
o=length(K);
for a=1:o-1
for u=1:o-1
    if K(u)>K(u+1)
        i=K(u);
        K(u)=K(u+1);
        K(u+1)=i;
    end
end
end
n=uint8(o)/2;
if o==2*n
    p=((K(n)+K(n+1))/2);
else
    p=K(n);
end