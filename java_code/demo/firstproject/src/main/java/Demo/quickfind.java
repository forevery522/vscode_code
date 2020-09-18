package Demo;

import java.util.Scanner;

public class quickfind {
    private int[] id;

    public quickfind(int N){
        id = new int[N];
        for (int i = 0; i < N; i++){
            id[i] = i;
        }
    }
    public static void main(String[] args) {
        Scanner Nscanner = new Scanner(System.in);
        int N = Nscanner.nextInt();
        quickfind qk = new quickfind(N);
        while (true) {
            Scanner pScanner = new Scanner(System.in);
            Scanner qScanner = new Scanner(System.in);
            int p = pScanner.nextInt();
            int q = qScanner.nextInt();
            System.out.println("result:\n");
            qk.union(p, q);
        }
    }
    public int find(int p){
        return id[p];
    }
    public void union(int p, int q){
        int pID = find(p);
        int qID = find(q);
        if (pID == qID) return;
        for (int i = 0; i < id.length; i++){
            if(id[i] == pID) id[i] = qID;
        }
        for (int i = 0; i < id.length; i++){
            System.out.println(id[i]);
        }
        
    }
}
