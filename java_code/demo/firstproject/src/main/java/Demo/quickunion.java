package Demo;

import java.util.Scanner;

public class quickunion {
        private int[] id;
    
        public quickunion(int N){
            id = new int[N];
            for (int i = 0; i < N; i++){
                id[i] = i;
            }
        }
    public static void main(String[] args) {
        int N = 10;
        quickunion qk = new quickunion(N);
        int count = 8;
        while (count>0) {
            Scanner pScanner = new Scanner(System.in);
            Scanner qScanner = new Scanner(System.in);
            int p = pScanner.nextInt();
            int q = qScanner.nextInt();
            System.out.println("result:");
            qk.union(p, q);
            count--;
        }
    }
    public int find(int p) {
        while (id[p] != p) {
            p = id[p];
        }
        return p;
    }
    public void union(int p, int q) {
        int proot = find(p);
        int qroot = find(q);
        if (proot == qroot) {
            return;
        }
        id[proot] = qroot;
        for (int i = 0; i < id.length; i++) {
            System.out.println(id[i]);
        }
    }
}
