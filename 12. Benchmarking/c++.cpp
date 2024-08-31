#include <iostream>
#include <fstream>
#include <vector>
#include <iomanip>

using namespace std;

// Fungsi untuk membaca matrix dari file
void readMatrix(const string &filename, vector<vector<double>> &matrix) {
    ifstream file(filename);
    if (!file.is_open()) {
        cerr << "Tidak bisa membuka file: " << filename << endl;
        exit(EXIT_FAILURE);
    }
    int n;
    file >> n;
    matrix.resize(n, vector<double>(n));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            file >> matrix[i][j];
        }
    }
    file.close();
}

// Fungsi untuk menulis matrix ke file
void writeMatrix(const string &filename, const vector<vector<double>> &matrix) {
    ofstream file(filename);
    if (!file.is_open()) {
        cerr << "Tidak bisa membuka file: " << filename << endl;
        exit(EXIT_FAILURE);
    }
    int n = matrix.size();
    file << n << endl;
    for (const auto &row : matrix) {
        for (double val : row) {
            file << fixed << setprecision(6) << val << " ";
        }
        file << endl;
    }
    file.close();
}

bool invertMatrix(vector<vector<double>> &matrix, vector<vector<double>> &inverse) {
    int n = matrix.size();
    inverse = vector<vector<double>>(n, vector<double>(n, 0.0));
    for (int i = 0; i < n; ++i) {
        inverse[i][i] = 1.0;
    }

    for (int i = 0; i < n; ++i) {
        double diag = matrix[i][i];
        if (diag == 0) {
            cerr << "Matrix tidak bisa diinversi (determinannya 0)." << endl;
            return false;
        }
        for (int j = 0; j < n; ++j) {
            matrix[i][j] /= diag;
            inverse[i][j] /= diag;
        }
        for (int k = 0; k < n; ++k) {
            if (k != i) {
                double factor = matrix[k][i];
                for (int j = 0; j < n; ++j) {
                    matrix[k][j] -= factor * matrix[i][j];
                    inverse[k][j] -= factor * inverse[i][j];
                }
            }
        }
    }
    return true;
}

int main() {
    vector<vector<double>> matrix, inverse;
    string inputFile = "input_matrix.txt";
    string outputFile = "output_matrix.txt";

    readMatrix(inputFile, matrix);

    if (invertMatrix(matrix, inverse)) {
        writeMatrix(outputFile, inverse);
	}

    return 0;
}