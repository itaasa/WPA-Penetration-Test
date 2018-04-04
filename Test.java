package scripts;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Test {

	public static void main(String args[]) throws Exception {

		String inDriver = "com.mysql.jdbc.Driver";
		String inUrl = "jdbc:mysql://localhost:3306/liveosbotdb";
		String inUser = "root";
		String inPass = "";
		DBUpdater db = new DBUpdater(inDriver, inUrl, inUser, inPass);
		
		displayHeaderText();
		pressAnyKeyToContinue();
		
		while (true){
			db.executeProc();
		}
	}
	
	public static void displayHeaderText () {
		FileReader fr;
		BufferedReader br;
		String buff;
		
		String path = System.getProperty("user.dir") + File.separator + "introtext" + File.separator 
				+ "header.txt";
		
		try {
			fr = new FileReader (path);
			br = new BufferedReader (fr);
			
			while((buff = br.readLine()) != null) {
				System.out.println(buff);
			}
			
			br.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	 public static void pressAnyKeyToContinue()
	 { 
	        System.out.println("Press Enter key to continue...");
	        try
	        {
	            System.in.read();
	        }  
	        catch(Exception e)
	        {}  
	 }

}
