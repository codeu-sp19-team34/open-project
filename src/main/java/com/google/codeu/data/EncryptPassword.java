package test;

import java.math.BigInteger;
import java.util.Random;

//help from samfoundary.com

public class EncryptPassword {
	
	public String password;
	private byte[] stringbytes;
	private byte[] encryptedpwd;
	private Random random;
	private BigInteger publickey;
	private BigInteger privatekey;
	private BigInteger prime1; //p
	private BigInteger prime2; //q
	private BigInteger exponent;
	private BigInteger phi; 
	
	
	/**
	 * constructor
	 * @param password (the user's original unencrypted password)
	 */
	public EncryptPassword(String password) {
		this.password = password;
		this.stringbytes = this.password.getBytes();
		random = new Random();
		prime1 = BigInteger.probablePrime(1024, random);
		prime2 = BigInteger.probablePrime(1024, random);
		publickey = prime1.multiply(prime2); //n = p*q
		exponent = BigInteger.probablePrime(256, random);
		phi = prime1.subtract(BigInteger.ONE).multiply(prime2.subtract(BigInteger.ONE));
		
		//how we generate the private key
		while (phi.gcd(exponent).compareTo(BigInteger.ONE) > 0 && exponent.compareTo(phi) < 0) {
			exponent.add(BigInteger.ONE);
		}
		
		privatekey = exponent.modInverse(phi);
	}
	
	/**
	 * performEncryption()
	 * @return (p*q)^e to encrypt
	 */
	public String performEncryption() {
		encryptedpwd = (new BigInteger(stringbytes)).modPow(exponent, publickey).toByteArray();
		return convertBytesToString(encryptedpwd);
	}
	
	/**
	 * performDecryption()
	 * @return encryptedpwd^privatekey mod public key
	 */
	public String performDecryption() {
		return convertBytesToString((new BigInteger(encryptedpwd)).modPow(privatekey, publickey).toByteArray());
	}
	
	public String convertBytesToString(byte[] data) {
		String bytestring = "";
		for (byte bite: data) {
			char c = (char)bite;
			bytestring += c;
		}
		
		return bytestring;
	}
	
	public static void main(String[] args) {
		EncryptPassword pwd = new EncryptPassword("codeu");
		System.out.println("Encrypt " + pwd.performEncryption());
		System.out.println("Decrypt " + pwd.performDecryption());
	}
	

}
