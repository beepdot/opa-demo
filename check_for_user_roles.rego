package rbac
import future.keywords.in

default allowed = false

token := input.token

authorization := {"header": header, "payload": payload} {
    [header, payload, _] := io.jwt.decode(token)
}


validate_token {
    now := time.now_ns()
    io.jwt.verify_hs256(token, "mysecret")
    authorization.payload.exp * 1000000000 > now
}

allowed {
    validate_token
    roles := authorization.payload.roles
    "writer" in roles
    #trace(sprintf("%v", roles))
}


# For this policy, we will be using the below HS256 token
# eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNjYxMzI2MjY4LCJleHAiOjE3ODc1MzY5MDksInJvbGVzIjpbInJlYWRlciIsIndyaXRlciJdfQ.W7cKk2njoWdgVc0OKHwXmi2zn0pSBNqnDxB4xIXFSK4
# HS256 secret key is mysecret