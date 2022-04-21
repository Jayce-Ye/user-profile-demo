package util;

import org.apache.commons.lang3.RandomUtils;

import java.util.ArrayList;

public class RandomNumBuilder {

    ArrayList<Integer> numPool=null;

    public   RandomNumBuilder(int fromNum,int toNum,  Integer... weights){
        numPool=new ArrayList<>();

        int index=0;
        for (int num=fromNum ;num<=toNum;num++){
            if(num>=weights.length){
                continue;
            }
            Integer weight = weights[index++];
            for (int k = 0; k < weight; k++) {
                numPool.add(num);
            }
        }
    }

    public int getNum(){
        return   numPool.get(  RandomUtils.nextInt(0,numPool.size()));
    }

    public static void main(String[] args) {
        RandomNumBuilder randomNumBuilder = new RandomNumBuilder(1, 10, 10, 10, 10, 10, 50, 1);
        for (int i = 0; i < 100; i++) {
            int num = randomNumBuilder.getNum();
            System.out.println(num);
        }

    }


}

