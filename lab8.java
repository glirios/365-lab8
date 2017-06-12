import java.sql.*;

public class lab8 {

	static Connection conn = null;


	public static void main(String args[])
	{

		String user = "USERNAME";
		String password = "PASSWORD";
		String url = "jdbc:mysql://cslvm74.csc.calpoly.edu/nyse";
		String query = "";

		try
		{
			Class.forName("com.mysql.jdbc.Driver");
		}
		catch (Exception ex)
		{
			System.out.println("Could not load driver");
			System.out.println(ex);
		}

		try
		{
			conn = DriverManager.getConnection(url, user, password);
		}
		catch (Exception ex)
		{
			System.out.println("Could not open connection");
			System.out.println(ex);
			System.exit(0);
		}

		System.out.println("Connected");
		/*
		try
		{
			Statement s1 = conn.createStatement();
			String table = "CREATE TABLE Books ";
			table += "(LibCode INT, Title VARCHAR(50), Author VARCHAR(20),";
			table += "PRIMARY KEY (LibCode) )";
			System.out.println(table);
			s1.executeUpdate(table);
		}
		catch (Exception ex)
		{
			System.out.println("Create table failed");
			System.out.println(ex);
		}


		try
		{
			Statement s2 = conn.createStatement();
			s2.executeUpdate("DROP TABLE Books");
		}
		catch (Exception ex)
		{
			System.out.println("Drop table failed");
			System.out.println(ex);
		}
		*/


		generalAnalysis();
		/*
		try
		{
			Statement s1 = conn.createStatement();
			query = "SELECT * FROM assignments WHERE"
					+ " student = 'kringler'";
			ResultSet result = s1.executeQuery(query);
			boolean f = result.next();
			while (f)
			{
				String s = result.getString("ticker");
				System.out.println(s);
				f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Query could not be executed");
			System.out.println(ex);
		}
		*/
	}


	public static void generalAnalysis()
	{
		String query = "";
		try
		{
			Statement s1 = conn.createStatement();
			query = "SELECT SUM(Volume) FROM Prices WHERE Day = "
					+ "(SELECT MIN(Day) FROM Prices WHERE Year(Day) = 2016 "
					+ "AND Month(Day) = 1)";
			ResultSet result = s1.executeQuery(query);
			boolean f = result.next();
			while (f)
			{
				long total = result.getLong(1);
				System.out.println("Total number of securities traded at the"
						+ " start of 2016");
				System.out.println(total);
            f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #1 Pt. 1");
			System.out.println(ex);
		}

		try
		{
			Statement s2 = conn.createStatement();
			query = "SELECT SUM(Volume) FROM Prices WHERE Day = "
					+ "(SELECT MAX(Day) FROM Prices WHERE Year(Day) = 2016 "
					+ "AND Month(Day) = 12)";
			ResultSet result = s2.executeQuery(query);
			boolean f = result.next();
			while (f)
			{
				long total = result.getLong(1);
				System.out.println("Total number of securities traded at the "
						+ "end of 2016");
				System.out.println(total);
            f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #1 Pt. 2");
			System.out.println(ex);
		}

		try
		{
			Statement s3 = conn.createStatement();
			query = "SELECT COUNT(*) FROM "
					+ "(SELECT * FROM Prices WHERE Day = "
					+ "(SELECT MAX(Day) FROM Prices WHERE Year(Day) = 2016"
					+ " AND Month(Day) = 12) GROUP BY Ticker) x, "
					+ "(SELECT * FROM Prices WHERE Day = "
					+ "(SELECT MAX(Day) FROM Prices WHERE Year(Day) = 2015"
					+ " AND Month(Day) = 12) GROUP BY Ticker) x1 "
					+ "WHERE x.Ticker = x1.Ticker AND x.Close > x1.Close";
			ResultSet result = s3.executeQuery(query);
			boolean f = result.next();
			while (f)
			{
				int total = result.getInt(1);
				System.out.println("Total number of securities whose prices saw"
						+ " an increase from end of 2015 to end of 2016");
				System.out.println(total);
            f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #1 Pt. 3");
			System.out.println(ex);
		}

		try
		{
			Statement s4 = conn.createStatement();
			query = "SELECT COUNT(*) FROM "
					+ "(SELECT * FROM Prices WHERE Day = "
					+ "(SELECT MAX(Day) FROM Prices WHERE Year(Day) = 2016"
					+ " AND Month(Day) = 12) GROUP BY Ticker) x, "
					+ "(SELECT * FROM Prices WHERE Day = "
					+ "(SELECT MAX(Day) FROM Prices WHERE Year(Day) = 2015"
					+ " AND Month(Day) = 12) GROUP BY Ticker) x1 "
					+ "WHERE x.Ticker = x1.Ticker AND x.Close < x1.Close";
			ResultSet result = s4.executeQuery(query);
			boolean f = result.next();
			while (f)
			{
				int total = result.getInt(1);
				System.out.println("Total number of securities whose prices"
						+ " saw a decrease from end of 2015 to end of 2016");
				System.out.println(total);
            f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #1 Pt. 4");
			System.out.println(ex);
		}

		try
		{
			Statement s5 = conn.createStatement();
			query = "SELECT Ticker FROM Prices WHERE Year(Day) = 2016"
					+ " GROUP BY Ticker ORDER BY (Volume) DESC LIMIT 10";
			ResultSet result = s5.executeQuery(query);
			boolean f = result.next();
			System.out.println("Top 10 stocks that were most heavily traded"
					+ " in 2016");
			while (f)
			{
				String s = result.getString(1);
				System.out.println(s);
				f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #2");
			System.out.println(ex);
		}

		try
		{
			Statement s6 = conn.createStatement();
			query = "SELECT DISTINCT YEAR(Day) FROM Prices";
			ResultSet result = s6.executeQuery(query);
			boolean f = result.next();
			System.out.println("For each year, Top 5 highest performing stocks "
					+ "for both absolute and relative price increase");
			while(f)
			{
				int year = result.getInt(1);
				try
				{
					Statement s7 = conn.createStatement();
					query = "SELECT x.Ticker FROM "
							+ "(SELECT Ticker, Close FROM Prices WHERE Day = "
							+ "(SELECT MAX(Day) FROM Prices WHERE "
							+ "Year(Day) = " + year + " AND Month(Day) = 12) "
							+ "GROUP BY Ticker) x, "
							+ "(SELECT Ticker, Close FROM Prices WHERE Day = "
							+ "(SELECT MIN(Day) FROM Prices WHERE "
							+ "Year(Day) = " + year + " AND Month(Day) = 12) "
							+ "GROUP BY Ticker) x1 "
							+ "WHERE x.Ticker = x1.Ticker "
							+ "ORDER BY (x.Close - x1.Close) DESC LIMIT 5";
					ResultSet result1 = s7.executeQuery(query);
					System.out.println("Top 5 absolute for year " + year);
					boolean f1 = result1.next();
					while (f1)
					{
						String s1 = result1.getString(1);
						System.out.println(s1);
						f1 = result1.next();
					}
					Statement s8 = conn.createStatement();
					query = "SELECT x.Ticker FROM "
							+ "(SELECT Ticker, Close FROM Prices WHERE Day = "
							+ "(SELECT MAX(Day) FROM Prices WHERE "
							+ "Year(Day) = " + year + " AND Month(Day) = 12) "
							+ "GROUP BY Ticker) x, "
							+ "(SELECT Ticker, Close FROM Prices WHERE Day = "
							+ "(SELECT MIN(Day) FROM Prices WHERE "
							+ "Year(Day) = " + year + " AND Month(Day) = 1) "
							+ "GROUP BY Ticker) x1 "
							+ "WHERE x.Ticker = x1.Ticker "
							+ "ORDER BY ((x.Close - x1.Close)/ x1.Close) DESC"
							+ " LIMIT 5";
					ResultSet result2 = s8.executeQuery(query);
					System.out.println("Top 5 relative for year " + year);
					boolean f2 = result2.next();
					while (f2)
					{
						String s2 = result2.getString(1);
						System.out.println(s2);
						f2 = result2.next();
					}
				}
				catch (Exception ex)
				{
					System.out.println("Could not get absolute or relative "
							+ "for year " + year);
					System.out.println(ex);
				}
				f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #3");
			System.out.println(ex);
		}

		try
		{
			Statement s9 = conn.createStatement();
			query = "SELECT x.Ticker FROM "
					+ "(SELECT Ticker, AVG(Close) AS Avg FROM Prices WHERE "
					+ "Year(Day) = 2016 AND MONTH(Day) = 1 "
					+ "GROUP BY Ticker) x, "
					+ "(SELECT Ticker, AVG(Close) AS Avg FROM Prices WHERE "
					+ "Year(Day) = 2016 AND MONTH(Day) = 12 "
					+ "GROUP BY Ticker) x1 "
					+ "WHERE x.Ticker = x1.Ticker "
					+ "ORDER BY ((x1.Avg - x.Avg) / x.Avg) DESC LIMIT 10";
			ResultSet result = s9.executeQuery(query);
			boolean f = result.next();
			System.out.println("10 Stocks to watch");
			while (f)
			{
				String s = result.getString(1);
				System.out.println(s);
				f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #4");
			System.out.println(ex);
		}

		try
		{
			Statement s10 = conn.createStatement();
			query = "SELECT DISTINCT Sector FROM Securities";
			ResultSet result = s10.executeQuery(query);
			boolean f = result.next();
			System.out.println("Assessments for different sectors");
			while (f)
			{
				String sector = result.getString(1);
				if (!"Telecommunications Services".equals(sector))
				{
					System.out.println("For Sector " + sector);
					try
					{
						Statement s11 = conn.createStatement();
						query = "SELECT AVG(y.Avg) FROM "
								+ "(SELECT x1.Ticker, "
								+ "((x2.Avg - x1.Avg) / x1.Avg) AS Avg FROM "
								+ "(SELECT Ticker FROM Securities "
								+ "WHERE Sector = '" + sector + "') x, "
								+ "(SELECT Ticker, AVG(Close) AS Avg "
								+ "FROM Prices WHERE MONTH(Day) = 1 AND "
								+ "Year(Day) = 2016 "
								+ "GROUP BY Ticker) x1, "
								+ "(SELECT Ticker, AVG(Close) AS Avg "
								+ "FROM Prices WHERE MONTH(Day) = 12 AND "
								+ "Year(Day) = 2016 GROUP BY Ticker) x2 "
								+ "WHERE x1.Ticker = x2.Ticker "
								+ "AND x.Ticker = x1.Ticker) y";
						ResultSet result1 = s11.executeQuery(query);
						boolean f1 = result1.next();
						while (f1)
						{
							float avg = result1.getFloat(1);
							if (avg < .02)
							{
								System.out.println("Unsafe");
							}
							else if (avg < .05)
							{
								System.out.println("Stationary");
							}
							else if (avg < .10)
							{
								System.out.println("Showing resilience");
							}
							else if (avg < .25)
							{
								System.out.println("Secure");
							}
							else
							{
								System.out.println("Significantly"
										+ " outperforming");
							}
							f1 = result1.next();
						}
					}
					catch (Exception ex)
					{
						System.out.println("Assessment could not be computed"
								+ " for sector " + sector);
						System.out.println(ex);
					}
				}
				f = result.next();
			}
		}
		catch (Exception ex)
		{
			System.out.println("Could not obtain the General Stock Market "
					+ "Analysis #5");
			System.out.println(ex);
		}

	}
}
