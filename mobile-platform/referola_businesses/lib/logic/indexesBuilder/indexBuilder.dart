class IndexBuilder{

  List<String> build(String keywords){
    List<String> subq = keywords.split(" ");
    List<String> finalSubQLis = [];

    for(int i=0; i<subq.length; i++){
      subq[i] = subq[i].trim();
    }
    for(int i=0; i<subq.length; i++){
      if(subq[i].isNotEmpty){
        finalSubQLis.add(subq[i]);
      }
    }

    List<String> finalData = finalSubQLis;

    List<String> queryList = [];
    List<String> queryListWithNoDuplicates = [];

    List<String> searchIndexes = [];
    for(int i=0; i<finalData.length; i++){
      queryList.addAll(finalData[i].split(" "));
    }
    queryListWithNoDuplicates = queryList.toSet().toList();
    print(queryListWithNoDuplicates);

    for(int i=0; i<queryListWithNoDuplicates.length; i++){
      for(int j=0; j<queryListWithNoDuplicates[i].length; j++){
        searchIndexes.add(queryListWithNoDuplicates[i].substring(0, j+1).toLowerCase());
      }
    }

    return searchIndexes;

  }

  List<String> buildWordBreak(String keywords){
    List<String> subq = keywords.split(" ");
    List<String> finalSubQLis = [];

    for(int i=0; i<subq.length; i++){
      subq[i] = subq[i].trim();
    }
    for(int i=0; i<subq.length; i++){
      if(subq[i].isNotEmpty){
        finalSubQLis.add(subq[i]);
      }
    }

    List<String> finalData = finalSubQLis;

    List<String> queryList = [];
    List<String> queryListWithNoDuplicates = [];

    
    for(int i=0; i<finalData.length; i++){
      queryList.addAll(finalData[i].split(" "));
    }
    queryListWithNoDuplicates = queryList.toSet().toList();
    print(queryListWithNoDuplicates);
    return queryListWithNoDuplicates;
  }

  
}