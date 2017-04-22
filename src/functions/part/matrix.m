%Helper function for creating matrixes
function matr = matrix(m,n,func)
   matr = func(repmat((1:m)',1,n)); 
end
