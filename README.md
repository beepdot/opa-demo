# opa-demo


### Download OPA
Download opa from the URL -
https://www.openpolicyagent.org/docs/latest/#running-opa

### Opa Interactive Mode
Start opa in interactive mode
```
opa run
```

### Simple OPA Commands
Lets run a few simple opa commands to understand rego language
#### Variables
```
# assign two variables integer values
x := 2
y := 3

# print variable values
x
y
```

#### Boolean
```
# assign two varaibles boolean values
allowed := true
deny := false

# print variable values
allowed
deny
```

#### Operators
```
# perform few arithmetic operations on the variables
x + y
x < y
x > y
```

#### Arrays
```
# create an array and print few values and length
arr := [3, 4, 5, 6, 7]
arr
arr[2]
count(arr)
```

#### Objects
```
# create an object and print few values and length
obj := {"country": "india", "state": "karnataka", "user": {"name": "ram", "age": "21"}}
obj.country
obj.user.name
count(obj)
count(obj.user)
```

#### Sets
```
# create a set and print few values and length
numbers := {5, 6, 7, 8, 9}
numbers
numbers[7]
```

#### In function
```
# check if a value exists in an array or set
import future.keywords.in
7 in numbers
70 in numbers
1 in arr
5 in arr
```

#### Check the data type
```
# check the variable's type
type_name(numbers)
type_name(arr)
```

#### JWT functions
```
# Create  and print two JWT tokens - One of HS256 and one of RS256 encoding
hsjwt := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.drt_po6bHhDOF_FJEHTrK-KD8OGjseJZpHwHIgsnoTM"

hsjwt

rsjwt := "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.Eci61G6w4zh_u9oOCk_v1M_sKcgk0svOmW4ZsL-rt4ojGUH2QY110bQTYNwbEVlowW7phCg7vluX_MCKVwJkxJT6tMk2Ij3Plad96Jf2G2mMsKbxkC-prvjvQkBFYWrYnKWClPBRCyIcG0dVfBvqZ8Mro3t5bX59IKwQ3WZ7AtGBYz5BSiBlrKkp6J1UmP_bFV3eEzIHEFgzRa3pbr4ol4TK6SnAoF88rLr2NhEz9vpdHglUMlOBQiqcZwqrI-Z4XDyDzvnrpujIToiepq9bCimPgVkP54VoZzy-mMSGbthYpLqsL_4MQXaI1Uf_wKFAUuAtzVn4-ebgsKOpvKNzVA"

rsjwt

# Create a variable to hold the RSA public key

cert := `-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo
4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u
+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh
kd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ
0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg
cKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc
mwIDAQAB
-----END PUBLIC KEY-----`

cert

# Decode the JWT tokens

io.jwt.decode(hsjwt)

io.jwt.decode(rsjwt)

# Verify the JWT tokens

io.jwt.verify_hs256(hsjwt, "mysecret")

io.jwt.verify_rs256(rsjwt, cert)
```

### Opa Policies

#### Always Allowed
Lets run an opa policy file that always gives output as true
```
# on one terminal run opa in server mode and pass the rego file as data
opa run -s always_allow.rego

# open another terminal invoke the opa endpoint using curl
curl localhost:8181/v1/data/common/allowed

# in the above curl command
# - common -> package name
# - allowed -> variable / method defined in the policy
# - data -> the policies get loaded under the data document
```

#### Always Denied
```
# stop the opa server and rerun with a different policy file
# on one terminal run opa in server mode and pass the rego file as data
opa run -s always_deny.rego

# open another terminal invoke the opa endpoint using curl
curl localhost:8181/v1/data/generic/allowed
```

#### Multiple Policy Files
```
# stop the opa server and rerun with a different policy file
# on one terminal run opa in server mode and pass the rego files as data
opa run -s always_allow.rego always_deny.rego

# open another terminal invoke the opa endpoint using curl
curl localhost:8181/v1/data/common/allowed
curl localhost:8181/v1/data/generic/allowed

```

#### Policy with an input
```
# stop the opa server and rerun with a different policy file
# on one terminal run opa in server mode and pass the rego file as data
opa run -s policy_with_input.rego

# open another terminal invoke the opa endpoint using curl
curl localhost:8181/v1/data/user/allowed
curl localhost:8181/v1/data/user/allowed -d '{"input": {"username": "alice"}}'
```


#### A simple RBAC Policy
```
# stop the opa server and rerun with a different policy file
# on one terminal run opa in server mode and pass the rego file as data
opa run -s check_for_user_roles.rego

# open another terminal invoke the opa endpoint using curl
curl localhost:8181/v1/data/rbac/allowed -d '{"input": {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjYxMzI2MjY4LCJleHAiOjE3ODc1MzY5MDksInJvbGVzIjpbInJlYWRlciIsIndyaXRlciJdfQ.W7cKk2njoWdgVc0OKHwXmi2zn0pSBNqnDxB4xIXFSK4"}}'
```


#### A simple RBAC Policy Based on API Path
```
# stop the opa server and rerun with a different policy file
# on one terminal run opa in server mode and pass the rego file as data
opa run -s check_for_user_roles_with_api.rego

# open another terminal invoke the opa endpoint using curl
curl localhost:8181/v1/data/rbacapi/allowed -d '{"input": {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjYxMzI2MjY4LCJleHAiOjE3ODc1MzY5MDksInJvbGVzIjpbInJlYWRlciIsIndyaXRlciJdfQ.W7cKk2njoWdgVc0OKHwXmi2zn0pSBNqnDxB4xIXFSK4"}}'
curl localhost:8181/v1/data/rbacapi/allowed -d '{"input": {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjYxMzI2MjY4LCJleHAiOjE3ODc1MzY5MDksInJvbGVzIjpbInJlYWRlciIsIndyaXRlciJdfQ.W7cKk2njoWdgVc0OKHwXmi2zn0pSBNqnDxB4xIXFSK4", "path": "/reader/api"}}'
curl localhost:8181/v1/data/rbacapi/allowed -d '{"input": {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjYxMzI2MjY4LCJleHAiOjE3ODc1MzY5MDksInJvbGVzIjpbInJlYWRlciIsIndyaXRlciJdfQ.W7cKk2njoWdgVc0OKHwXmi2zn0pSBNqnDxB4xIXFSK4", "path": "/writer/api"}}'
curl localhost:8181/v1/data/rbacapi/allowed -d '{"input": {"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjYxMzI2MjY4LCJleHAiOjE3ODc1MzY5MDksInJvbGVzIjpbInJlYWRlciIsIndyaXRlciJdfQ.W7cKk2njoWdgVc0OKHwXmi2zn0pSBNqnDxB4xIXFSK4", "path": "/admin/api"}}'
```


### OPA Architecture on Kubernetes
See this link - https://www.openpolicyagent.org/docs/latest/envoy-introduction/