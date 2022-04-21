package util;

import java.util.Random;

public class RandomNum {
    public static final  int getRandInt(int fromNum,int toNum){

        return   fromNum+ new Random().nextInt(toNum-fromNum+1);
    }

    public static final  Long getRandLong(int fromNum,int toNum){

        return   fromNum+ new Random().nextInt(toNum-fromNum+1)+0L;
    }



    public static final  int getRandInt(int fromNum,int toNum,Long seed){

        return   fromNum+ new Random(seed).nextInt(toNum-fromNum+1);
    }



}

