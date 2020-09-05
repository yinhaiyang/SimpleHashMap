class SimpleHashMap {
  double _loadFactor = 0.75; // 0.5 for Testing
  final int _defaultSize = 4;

  List<SimpleMapEntry> _buckets;

  SimpleHashMap([int initialSize]) {
    if (null == initialSize || initialSize == 0) {
      _buckets = new List(_defaultSize);
    } else {
      _buckets = new List(initialSize);
    }
  }

  String get(String key) {
    int hash = _hash(key);
    int index = hash % _buckets.length;
    SimpleMapEntry node = _buckets[index];
    if (null == node) {
      return null;
    } else if (node.key == key) {
      return node.value;
    } else {
      do {
        node = node.next;
        if (node.key == key) {
          return node.value;
        }
      } while (null != node.next);
    }
    return null;
  }

  put(String key, String value) {
    resizeBuckets();
    int hash = _hash(key);
    int index = hash % _buckets.length;
    SimpleMapEntry node = _buckets[index];
    if (null == node) {
      _buckets[index] = new SimpleMapEntry(hash, key, value, null);
    } else if (null == node.next) {
      if (node.hash == _hash(key) && node.key == key) {
        node.value = value;
      } else {
        node.next = new SimpleMapEntry(hash, key, value, null);
      }
    } else {
      do {
        node = node.next;
      } while (null != node.next);
      if (node.hash == _hash(key) && node.key == key) {
        node.value = value;
      } else {
        node.next = new SimpleMapEntry(hash, key, value, null);
      }
    }
  }

  int _hash(String key) {
    return key.hashCode;
  }

  int length() {
    int size = 0;
    for (int i = 0; i < _buckets.length; i++) {
      if (null != _buckets[i]) {
        size++;
      }
    }
    return size;
  }

  List<SimpleMapEntry> getBuckets() {
    return _buckets;
  }

  /// todo resize when node / length much smaller than loadFactor
  void remove(String key) {
    /// todo non-null or no such key check
    int hash = key.hashCode;
    int index = hash % _buckets.length;
    SimpleMapEntry node = _buckets[index];
    // First node needs to be removed
    // Set to null if next is null or node = next(null)
    if (node.key == key && node.hash == hash) {
      // node = node.next;
      _buckets[index] = node.next;
      // todo Don't know why for now? To do more research
      // todo Only deleting the first node needs to use the origin array
      return;
    }
    SimpleMapEntry nextNode = node.next;
    // Not the first node, then check every next node
    while (node.hash != hash || node.key != key) {
      if (null != nextNode && nextNode.hash == hash && nextNode.key == key) {
        node.next = nextNode.next;
        return;
      }
      node = node.next;
    }
  }

  void resizeBuckets() {
    if (length() / _buckets.length > _loadFactor) {
/*      List<SimpleMapEntry> newBuckets = List(_buckets.length*2);
      for(int i=0;i<_buckets.length;i++){
        SimpleMapEntry node = _buckets[i];
        while(null !=node){
          int newHash = node.key.hashCode;
          int newIndex = newHash % newBuckets.length;
        }
      }*/
      SimpleHashMap newMap = SimpleHashMap(_buckets.length * 2);
      for (int i = 0; i < _buckets.length; i++) {
        SimpleMapEntry node = _buckets[i];
        while (null != node) {
          newMap.put(node.key, node.value);
          node = node.next;
        }
      }
      _buckets = newMap._buckets;
    }
  }
}

class SimpleMapEntry {
  int hash;
  String key;
  String value;
  SimpleMapEntry next;

  SimpleMapEntry(this.hash, this.key, this.value, this.next);
}
