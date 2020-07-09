import java.util.Scanner;

public class HackerRank1 {

    public static void main(String[] args) {
            Scanner sc=new Scanner(System.in);
            String[] tam = new String[3];
            String[] s2 = new String[3];

            System.out.println("================================");
            for(int i=0;i<3;i++)
            {
                String s1=sc.next();
                s2[i] = s1;

                int x=sc.nextInt();
                String y = Integer.toString(x);
                tam[i] = y;

            }
            
            
            for (int i = 0; i < 3; i++){
            	if (tam[i].length() == 2){
            		tam[i] = "0" + tam[i];
            	}
            	else if (tam[i].length() == 1){
            		tam[i] = "00" + tam[i];
            	}

            }
         
            System.out.println(String.format("%-15s", s2[0]) + tam[0]);
            System.out.println(String.format("%-15s", s2[1]) + tam[1]);
            System.out.println(String.format("%-15s", s2[2]) + tam[2]);

            System.out.println("================================");
    }
}



