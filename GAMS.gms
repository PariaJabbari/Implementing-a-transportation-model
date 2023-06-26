Sets

i                  All customers           /0*10/
r(i)               Truck-only customers    /3,5/
f(i)               Mode-free customers     /0, 1, 2, 4, 6, 7, 8, 9, 10/ ;

Alias(i, j, l);
Alias(f, n);

Scalars

h                  Number of trucks
C                  Truck cost per km
Cp                 Drone cost per km
Q                  Truck payload capacity
Qp                 Drone payload capacity
Tm                 Maximum working time for truck
Tpm                Maximum working time for drone;

h=2;
C=0.03;
Cp=1.25;
Q=100;
Qp=2.27;
Tm=104;
Tpm=98;

Parameters

w(i)               Parcel weight of the customer i

/0  0, 1  2.5, 2  2.2, 3  14, 4  1.75, 5  13.5, 6  1.75, 7  2.27, 8  2, 9  0.5, 10  0.75/

Dp(f)              The total flying distance incurred by a drone to serve the customer i

/0  0, 1  62, 2  52, 4  51, 6  56, 7  63, 8  61, 9  52, 10  53/

Tp(f)              The total time incurred as a drone serves customer i

/0  0, 1  97, 2  90, 4  78, 6  87, 7  100, 8  97.5, 9  83, 10  84.3/ ;


Parameter d(i, j)  The distance required for a truck to traverse from node i to node j;

$call  GDXXRW  GAMS1.xlsx  par=d  rng=sheet1!a1:l12 rdim=1  cdim=1
$GDXIN GAMS1.gdx
$load d
$GDXIN

Parameter t(i, j)  The time spent by a truck to travel from node i to node j;

$call  GDXXRW  GAMS1.xlsx  par=t  rng=sheet1!a14:l25  rdim=1  cdim=1
$GDXIN  GAMS1.gdx
$load t
$GDXIN

Variables

obj
x(i, j)            Equal to 1 if node j is reached from node i by the trucks 0 otherwise
y(f)               Equal to 1 if node i is visited by drone k 0 otherwise
u(i)               Specifying the weight that a truck is carrying up to node i along the truck’s path
Z(i, j)            Representing the cumulative duration of the truck tour at node j after passing through node i;

Binary Variables
x,y;

Nonnegative Variables
u,z;

Equations

of
co2
co3(j)
co4(n)
co5(r)
co6(i,j)
co7
co8(i)
co9(i)
co10(i)
co11(i)
co12(i,j);

of                            .. obj=e=c*(sum((i,j),d(i,j)*x(i,j)))+Cp*(sum((f),dp(f)*y(f)));
co2                           .. sum((i),x("0",i))=l=h ;
co3(j)                        .. sum((i)$(ord(i) ne ord(j)),x(i, j))-sum((i)$(ord(i) ne ord(j)),x(j, i))=e=0;
co4(n)                        .. sum((f)$(ord(f) ne ord(n)),x(f, n))+y(n)=e=1;
co5(r)                        .. sum((i)$(card(i) ne card(r)) ,x(i, r))=e=1;
co6(i, j)$(ord(i) ne ord(j))  .. u(i)-u(j)+Q*x(i, j)=l=Q-w(j);
co7                           .. sum((n),y(n)*tp(n))=l=tpm;
co8(i)                        .. sum((l)$(ord(l) ne ord(i)),z(l, i))+sum((j)$(ord(i) ne ord(j)),t(i,j)*x(i,j))=e=sum((j),z(i, j));
co9(i)                        .. z("0",i)=e=t("0",i)*x("0", i);
co10(i)                       .. z(i, "0")=l=tm*x(i, "0");
co11(i)                       .. u(i)=l=Q;
co12(i, j)$(ord(i) ne ord(j)) .. z(i, j)=l=tm;

Model PDSVRP /all/;

Solve PDSVRP using MIP Minimizing obj;

Display obj.l;





































