package com.example.appengine.cloudsql;

import java.math.BigInteger;
import java.util.Random;

//help from samfoundary.com

public class EncryptPassword {

    public String password;
    private byte[] stringbytes;
    private byte[] encryptedpwd;
    private Random random;
    private BigInteger publickey; //n
    private BigInteger privatekey; //d
    private BigInteger prime1; //p
    private BigInteger prime2; //q
    private BigInteger exponent; //e
    private BigInteger phi;


    /**
     * constructor used for when we are creating a new user and adding an encrypted password to the database
     * @param password (the user's original unencrypted password)
     */
    public EncryptPassword(String password) {
        this.password = password;
        this.stringbytes = this.password.getBytes();
        random = new Random();

        //create your public key
        prime1 = BigInteger.probablePrime(128, random);
        prime2 = BigInteger.probablePrime(128, random);
        publickey = prime1.multiply(prime2); //n = p*q
        exponent = BigInteger.probablePrime(64, random); //e
        privatekey = createPrivateKey(); //d
    }

    /**
     * performEncryption()
     * @return (p*q)^e to encrypt the password that the user has chosen when creating their account
     */
    public String performEncryption() {
        encryptedpwd = new BigInteger(stringbytes).modPow(exponent, publickey).toByteArray();
        return convertBytesToString(encryptedpwd);
    }


    /**
     * constructor for when you are trying to create an object with an already encrypted password from database
     * @param password -- already encrypted
     * @param n - part of public key (prime*prime)
     * @param e - part of public key
     */
    public EncryptPassword(String password, BigInteger n, BigInteger e, BigInteger d){
        this.password = password;
        this.stringbytes = this.password.getBytes();
        this.publickey = n;
        this.exponent = e;
        this.privatekey = d;

    }

    /**
     * performDecryption()
     * @return stringbytes^privatekey mod public key (where string bytes is the bytes of the previously encrypted string)
     */
    public String performDecryption() {
        return convertBytesToString((new BigInteger(stringbytes)).modPow(privatekey, publickey).toByteArray());
    }

    public String convertBytesToString(byte[] data) {
        String bytestring = "";
        for (byte bite: data) {
            char c = (char)bite;
            bytestring += c;
        }

        return bytestring;
    }

    public BigInteger createPrivateKey() {

        phi = prime1.subtract(BigInteger.ONE).multiply(prime2.subtract(BigInteger.ONE));

        //how we generate the private key
        while (phi.gcd(exponent).compareTo(BigInteger.ONE) > 0 && exponent.compareTo(phi) < 0) {
            exponent = exponent.add(BigInteger.ONE);
        }

        privatekey = exponent.modInverse(phi); //d
        return privatekey;
    }

    public BigInteger getPublickey() {
        return publickey;
    }

    public BigInteger getPrivatekey() {
        return privatekey;
    }

    public BigInteger getExponent() {
        return exponent;
    }



}
