import java.util.*;


public class Delimiter {

    public static void main(String[] args) {

    	Scanner scan = new Scanner(System.in);
    	// scan.useDelimiter("\\.");
    	scan.useDelimiter("<para>");
    	String x = scan.next();

    	System.out.println("vc digitou: " + x);
        
        scan.close();
    }
}
