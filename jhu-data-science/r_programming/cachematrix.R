## makeCacheMatrix is used to cache the inverse of a matrix.
##      It takes a matrix as input and initializes 
##      an object with functions for getting and setting
##      the inverse of that matrix. Matrix is assumed to be 
##      a square matrix.
## example: 
## myMatrix <- makeCacheMatrix(matrix(runif(4, 1, 2), ncol = 2, nrow = 2))

makeCacheMatrix <- function(x = matrix()) {
    m_inv <- NULL
    set <- function(y){
        x <<- y
        m_inv <<- NULL
    }
    get <- function() x
    setinv <- function(solve) m_inv <<- solve
    getinv <- function() m_inv
    list(set = set, get = get,
         setinv = setinv, getinv = getinv)
}


## cacheSolve takes a makeCacheMatrix object and checks to see if
##      the inverse matrix has already been calculated and cached.
##      If cached, the cache is returned. Otherwise, the inverse matrix 
##      is calculated and cached for subsequent execution.
## example:
## cacheSolve(myMatrix) # First time returns calculated inverse matrix
## cacheSolve(myMatrix) # Second time returns cached inverse matrix

cacheSolve <- function(x, ...) {
    m_inv <- x$getinv() # Get cached value (if it exists)
    if(!is.null(m_inv)) { # If cached value exists...
        message("getting cached inverse matrix") # Tell user we're using cache
        return(m_inv) # Return cached inverse matrix
    } # Otherwise...
    data <- x$get() # Get data
    m_inv <- solve(data, ...) # Compute inverse matrix
    x$setinv(m_inv) # Set inverse matrix cache
    m_inv # Return inverse matrix
}
