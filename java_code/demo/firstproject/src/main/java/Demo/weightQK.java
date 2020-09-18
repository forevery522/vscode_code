package Demo;

import java.util.Scanner;

public class weightQK {
    private int[] id;
    private int[] size;
    public weightQK(int N){
        id = new int[N];
        size = new int[N];
        for (int i = 0; i < N; i++) {
            id[i] = i;
            size[i] = 1;
        }
    }
    public static void main(String[] args) {
        int N = 10;
        weightQK qk = new weightQK(N);
        int count = 8;
        while(count > 0){
            Scanner pScanner = new Scanner(System.in);
            Scanner qScanner = new Scanner(System.in);
            int p = pScanner.nextInt();
            int q = qScanner.nextInt();
            System.out.println("result:");
            qk.union(p, q);
            count--;
        }
    }
    public int find(int p){
        while (p != id[p]) {
            p = id[p];
        }
        return p;
    }
    public void union(int p, int q){
        int i = find(p);
        int j = find(q);
        if (i == j) {
            return;
        }
        if (size[i] < size[j]) {
            id[i] = j;
            size[j]+= size[i];
        }
        else{
            id[j] = i;
            size[i]+= size[j];
        }
        for (int m = 0; m < id.length; m++) {
            System.out.println(id[m]);
        }
    }
}
