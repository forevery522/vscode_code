package Demo;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( final String[] args)
    {
        int[] id;
        id = new int[10];
        for (int i = 0; i < id.length; i++){
            id[i] = i;
        }
        System.out.println(id);
    }
}
