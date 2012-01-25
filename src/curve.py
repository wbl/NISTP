#!/opt/local/python
#Curve.py
#Use arithmetic we know works to make NISTP work, then translate to C on
#top of fep256

prime = 2**256-2**224+2**192+2**96-1
paramb = 0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b 
basepx = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296
basepy = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5
#we use jacobian coordinates: doubling identity works
def pointadd(p1, p2):
    X1,Y1,Z1 = p1
    X2, Y2, Z2 = p2
    #note that Z->Z/pZ is a ring homomorphism
    #(that's the mathematics behind not putting % everywhere)
    #EFD add-2007-bl
    Z1Z1 = Z1**2
    Z2Z2 = Z2**2
    U1 = X1*Z2Z2
    U2 = X2*Z1Z1
    S1 = Y1*Z2*Z2Z2
    S2 = Y2*Z1*Z1Z1
    H = U2-U1
    I = (2*H)**2
    J = H*I
    r = 2*(S2-S1)
    V = U1*I
    X3 = r**2-J-2*V
    Y3 = r*(V-X3)-2*S1*J
    Z3 = ((Z1+Z2)**2-Z1Z1-Z2Z2)*H
    return (X3 % prime, Y3 %prime, Z3 % prime)
def pointdbl(p1):
    X1, Y1, Z1 = p1
    delta = Z1**2
    gamma = Y1**2
    beta = X1*gamma
    alpha = 3*(X1-delta)*(X1+delta)
    X3 = alpha**2-8*beta
    Z3 = (Y1+Z1)**2-gamma-delta
    Y3 = alpha*(4*beta-X3)-8*gamma**2
    return ( X3 % prime, Y3 % prime, Z3 %prime)

identity = (1, 1, 0)
basepoint = (basepx, basepy, 1)

def inv(a):
    return modpow(a, prime-2,prime) #use fact p is prime

def modpow(a, exp, p):
    if exp == 0:
        return 1
    elif exp%2 == 1:
        return (a*modpow(a,(exp/2), p)**2)%p
    else:
        return (modpow(a, (exp/2), p)**2)%p

def toaffine(p):
    x,y,z = p
    return ((x*inv(z)**2)%prime, (y*inv(z)**3)%prime)

def oncurve(p):
    (x,y)=toaffine(p)
    return (y**2)%prime==(x**3-3*x+paramb)%prime

def pointpow(p, n): #identy doesn't work, must fix
    if n == 0:
        return (1,1,0)
    elif (n%2)==1:
        return pointadd(p, pointdbl(pointpow(p, n/2)))
    else:
        return pointdbl(pointpow(p, n/2))

print oncurve(basepoint)
print oncurve(pointdbl(basepoint))
print oncurve(pointadd(basepoint, pointdbl(basepoint)))
print oncurve(pointadd(identity, basepoint))
print oncurve(pointadd(basepoint, identity))
#for i in xrange(1, 100):
#    print oncurve(pointpow(basepoint, i))
