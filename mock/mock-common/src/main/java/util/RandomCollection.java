package util;

import java.util.*;

public class RandomCollection  {


   public static<T>    T  getOneFrom(List<T> list){
        int randInt = RandomNum.getRandInt(0, list.size() - 1);
        return   list.get(randInt) ;
    }

    public static<T>    List<T>  getSomeFrom(List<T> list,Integer num){

        HashSet idxSet= new HashSet();
        List<T> rslist=new ArrayList<>();
         while(idxSet.size()!=num){
             int randIdx = RandomNum.getRandInt(0, list.size() - 1);
             if(!idxSet.contains(randIdx)){
                 idxSet.add(randIdx);
                 rslist.add(list.get(randIdx) );
             }
         }
        return   rslist;
    }

    public static<K,V>    V  getOneFrom(Map<K,V> hashMap, List<K> excludeKeyList){
        HashMap<K,V> cloneMap =  new HashMap();
        cloneMap.putAll(hashMap);
        for (K key : excludeKeyList) {
            cloneMap.remove(key);
        }
        Object[] values =  cloneMap.values().toArray();
        if(values.length>=1){
            int randInt = RandomNum.getRandInt(0, values.length  - 1);
            return  (V)values[randInt] ;
        }else {
            return  null;
        }



    }

}
