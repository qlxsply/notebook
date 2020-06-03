```java
ImmutableSet：不可变集合
ImmutableSet<String> immutableSet1 = ImmutableSet.of("RED", "GREEN");
ImmutableSet<String> immutableSet2 = ImmutableSet.copyOf(set);

Multiset：处于list和set之间，可以重复，不保证有序
key表示存储的对象，value表示该对象出现的次数，可以用来统计某一个对象出现的次数
add(E element): 向其中添加单个元素
add(E element,int occurrences): 向其中添加指定个数的元素
count(Object element): 返回给定参数元素的个数
remove(E element): 移除一个元素，其count值 会响应减少
remove(E element,int occurrences): 移除相应个数的元素
elementSet(): 将不同的元素放入一个Set中
entrySet(): 类似与Map.entrySet 返回Set<Multiset.Entry>。包含的Entry支持使用getElement()和getCount()
setCount(E element ,int count): 设定某一个元素的重复次数
setCount(E element,int oldCount,int newCount): 将符合原有重复个数的元素修改为新的重复次数
retainAll(Collection c): 保留出现在给定集合参数的所有的元素
removeAll(Collectionc): 去除出现给给定集合参数的所有的元素

Multimap：一个键对应到多个值，类似Map<String, List<User>> 
Multimap.size()返回的是entries的数量，而不是不重复键的数量。如果要得到不重复键的数目就得用Multimap.keySet().size()

BiMap：保证value也不重复，不仅key->value，也有value->key
inverse()反转BiMap<K, V>的键值映射，原来的BiMap并没有被更改，而且翻转前后BiMap是互相关联的，修改其中一个，另一个也会被修改。
```

