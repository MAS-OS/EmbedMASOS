package org.masos.embed.SysConf.controller;


public class Connection {
	
	private final Integer maxWifiScan 		= 16;							/*Número máximo de redes que serão listadas durante Scan*/ 
	private final String cmdLineScanWLAN	= "sudo iwlist scan";
	private final String cmdLineStatusWLAN 	= "sudo iwconfig 2>/dev/null";
	
	private String[][] listOfWLANs;
	private Integer numberOfWLANS;
	
	private String  interfaceWLAN;
	private String  ESSIDWLAN;
	private String  opModeWLAN;
	private Integer signalWLAN;
	private Double	mpbsWLAN;
	private Integer freqWLAN;
	private Double	qualityWLAN;
	
	private String 	usernameSSH;
	private String 	passwordSSH;
	private String 	hostnameSSH;
	private Integer	portSSH;
	
	SSHaux ssh;
	
	public Connection() {
		
	}

	public Connection(String usernameSSH, String passwordSSH) {
		this.usernameSSH 	= usernameSSH;
		this.passwordSSH 	= passwordSSH;
		this.hostnameSSH 	= "localhost";
		this.portSSH		= 22;
		
		this.ssh = new SSHaux(this.hostnameSSH, this.portSSH);
	}
	
	public Connection(String username, String password, String hostname, Integer port) {
		this.usernameSSH	= username;
		this.passwordSSH	= password;
		this.hostnameSSH	= hostname;
		this.portSSH		= port;
		
		this.ssh = new SSHaux(this.hostnameSSH, this.portSSH);
	}
	
	/************************  Métodos Públicos *******************/
	
	public void scanWLAN() {
		this.listOfWLANs = new String [maxWifiScan-1][6];
		
		this.ssh.connect(this.usernameSSH, this.passwordSSH);
		String in = this.ssh.exec(cmdLineScanWLAN);
		this.ssh.disconnect();
		
		treatWLANscanList(in);	
	}
	
	public String listWLANs() {
		return listWLAN(0);
	}
	
	public String listWLAN(int x) {
		String out ="<table>\n"
				+ "    <thead><tr>"
				+ "            <th>ID</th>"
				+ "            <th>ESSID</th>"
				+ "            <th>Channel</th>"
				+ "            <th>Frequency</th>"
				+ "            <th>Quality</th>"
				+ "            <th>Encripted</th>"
				+ "    </tr></thead>"
				+ "    <tbody>";
	
		
		for(int i=x; i<maxWifiScan-1; i++) {
			if(this.listOfWLANs[i][0]==null) {
				i=maxWifiScan+1;
			}else {
				out=out+"<tr>";
				out=out+"<td>"+this.listOfWLANs[i][0]+"</td>";
				out=out+"<td>"+this.listOfWLANs[i][1]+"</td>";
				out=out+"<td>"+this.listOfWLANs[i][2]+"</td>";
				out=out+"<td>"+this.listOfWLANs[i][3]+"</td>";
				out=out+"<td>"+this.listOfWLANs[i][4]+"</td>";
				out=out+"<td>"+this.listOfWLANs[i][5]+"</td>";
				out=out+"</tr>";
			}
			if(x>0) {
				i=maxWifiScan+x;
			}
		}
		out=out+"</tbody></table>";

		return out;
		
	}
	
	public void refreshWLAN() {	
		this.ssh.connect(usernameSSH,passwordSSH);
		String in = this.ssh.exec(cmdLineStatusWLAN);
		this.ssh.disconnect();
		
		setOpModeWLAN(extractField("Mode:", in));
		setInterfaceWLAN(in.substring(0,in.indexOf(" ")));
		setESSIDWLAN(extractField("ESSID:", in));
		setSignalWLAN(extractField("level=", in));
		setMpbsWLAN(extractField("Rate=", in));
		setFreqWLAN(extractField("Frequency:", in));
		setQualityWLAN(calcQuality(extractField("Quality=", in)));
	}
	
	public String statusWLAN() {
		String out ="<table>\n"
				+ "    <thead><tr>"
				+ "            <th>INTERFACE</th>"
				+ "            <th>ESSID</th>"
				+ "            <th>Mode</th>"
				+ "            <th>dBm</th>"
				+ "            <th>Mb/s</th>"
				+ "            <th>MHz</th>"
				+ "            <th>Quality</th>"
				+ "    </tr></thead>"
				+ "    <tbody><tr>";
	
		out = out+("<td>"+getInterfaceWLAN()+"</td>");
		out = out+("<td>"+getESSIDWLAN()+"</td>");
		out = out+("<td>"+getOpModeWLAN()+"</td>");
		out = out+("<td>"+getSignalWLAN()+"</td>");
		out = out+("<td>"+getMpbsWLAN()+"</td>");
		out = out+("<td>"+getFreqWLAN()+"</td>");
		out = out+("<td>"+getQualityWLAN()+"</td>");
		
		out=out+"</tr></tbody></table>";
		return out;
	}

	/************************* Setters **********************/
	private void setFreqWLAN(String freqWLAN) {
		try {
			this.freqWLAN = Integer.parseInt(freqWLAN.replaceAll("[^0-9]", ""));	
		}catch(Exception e) {
			e.printStackTrace();
			this.freqWLAN = null;
		}
	}

	private void setQualityWLAN(Double qualityWLAN) {
		this.qualityWLAN = qualityWLAN;
	}
	
	private void setMpbsWLAN(String mpbsWLAN) {
		try {
			this.mpbsWLAN = Double.parseDouble(mpbsWLAN);
		}catch(Exception e) {
			this.mpbsWLAN = null;
		}
		
	}
	
	private void setSignalWLAN(String signalWLAN) {
		Integer out = 0;
		try {
			Integer.parseInt(signalWLAN);
		}catch(Exception e) {
			
		}
			
		this.signalWLAN = out;
	}

	private void setOpModeWLAN(String opModeWLAN) {
		this.opModeWLAN = opModeWLAN;
	}	
	
	private void setESSIDWLAN(String eSSIDWLAN) {
		this.ESSIDWLAN = eSSIDWLAN;
	}
	
	private void setInterfaceWLAN(String interfaceWLAN) {
		this.interfaceWLAN = interfaceWLAN;
	}

	
	/*********************** Getters ************************/
	public Integer getFreqWLAN() {
		return freqWLAN;
	}
	
	public Double getQualityWLAN() {
		return qualityWLAN;
	}
	
	public Double getMpbsWLAN() {
		return mpbsWLAN;
	}

	public Integer getSignalWLAN() {
		return signalWLAN;
	}
	
	public String getOpModeWLAN() {
		return opModeWLAN;
	}
	
	public String getESSIDWLAN() {
		return ESSIDWLAN;
	}
	
	public String getInterfaceWLAN() {
		return interfaceWLAN;
	}

	public int getNumberOfWAN() {
		return this.numberOfWLANS;
	}
	
	
	/******************* Métodos auxiliares *****************/
	
	private Double calcQuality(String qualitySignal) {
		try {
			Double i =  Double.parseDouble(qualitySignal.substring(0, 1));
			Double j =  Double.parseDouble(qualitySignal.substring(3, 4));
			return Double.parseDouble(String.format("%.2f", i/j).replaceAll("[,]", "."));
		}catch (Exception e) {
			return null;
		}
	}
	
	private String extractField(String field,String input) {
		return extractField(field, input, 0);
	}
	
	private String extractField(String field, String input, int without) {
		String in = input.trim();	
		Integer i = in.indexOf(field);
		Integer j = in.indexOf(" ",i);
		String out;
		try {
			out = in.substring(i+field.length(),j-without);
		}catch (Exception e) {
			out = null;
		}
		return out;
	}
	
	private void treatWLANscanList(String input) {
		String identificador = "Cell";
		int x = 1;
		int y = 0;
		int z = 0;
		int wlan = 0;
		while(x>0) {
			x = input.indexOf(identificador, y);
			
			if((y>0)&&(x>0)){
				registerWLAN(input.substring(z, x),wlan);
				wlan++;
			}else if (x<0) {
				registerWLAN(input.substring(z, input.length()),wlan);
			}
			
			if(x>0) {
				y = x+1;
				z = x;
			}
			
			if(wlan>=maxWifiScan-1) {
				x=-1;
			}
		}	
	}
	
	private void registerWLAN(String input, Integer id) {
		if(!input.isEmpty()) {		
			this.listOfWLANs[id][0]=Integer.toString(id);
			this.listOfWLANs[id][1]=extractField("ESSID:", input,1);
			this.listOfWLANs[id][2]=extractField("Channel:", input,1);
			this.listOfWLANs[id][3]=extractField("Frequency:", input);
			this.listOfWLANs[id][4]=Double.toString(calcQuality(extractField("Quality=", input)));
			this.listOfWLANs[id][5]=extractField("key:", input,1);
			this.numberOfWLANS=id+1;
		}else {
			System.out.println("Wifi ativa?");
			this.numberOfWLANS=0;
		}
	}
	

}
