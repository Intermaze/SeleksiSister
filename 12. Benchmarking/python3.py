def read_matrix(file_path):
    with open(file_path, 'r') as file:
        matrix = [list(map(float, line.split())) for line in file]
    return matrix

def write_matrix(file_path, matrix):
    with open(file_path, 'w') as file:
        for row in matrix:
            file.write(' '.join(map(str, row)) + '\n')

def invert_matrix(matrix):
    n = len(matrix)
    augmented_matrix = [matrix[i] + [0 for _ in range (n)] for i in range(n)]
    matrix = augmented_matrix
    
    # Create the augmented matrix
    for i in range(n):
        for j in range(2 * n):
            # Add '1' at the diagonal places of the matrix to create an identity matrix
            if j == (i + n):
                matrix[i][j] = 1

    # Interchange the row of matrix, interchanging of row will start from the last row
    for i in range(n - 1, 0, -1):
        if matrix[i - 1][0] < matrix[i][0]:
            tempArr = matrix[i]
            matrix[i] = matrix[i - 1]
            matrix[i - 1] = tempArr

    # Replace a row by the sum of itself and a multiple of another row
    for i in range(n):
        for j in range(n):
            if j != i:
                temp = matrix[j][i] / matrix[i][i]
                for k in range(2 * n):
                    matrix[j][k] -= matrix[i][k] * temp

    for i in range(n):
        temp = matrix[i][i]
        for j in range(2 * n):
            matrix[i][j] = matrix[i][j] / temp

    return [row[n:] for row in matrix]

def main(input_file, output_file):
    matrix = read_matrix(input_file)
    inverse_matrix = invert_matrix(matrix)
    write_matrix(output_file, inverse_matrix)

input_file = 'input_matrix.txt'
output_file = 'output_matrix.txt'
main(input_file, output_file)
