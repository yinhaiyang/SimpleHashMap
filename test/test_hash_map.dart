import 'package:flutter_test/flutter_test.dart';
import 'package:hash_map/simple_hash_map.dart';

void main() {
  test("test", () {
    SimpleHashMap simpleHashMap = new SimpleHashMap();
    SimpleHashMap simpleHashMap2 = new SimpleHashMap(12);
    simpleHashMap.put("1", "11");
    simpleHashMap.put("2", "22");
    simpleHashMap.put("3", "33");
    expect(simpleHashMap.length(), 3);
    expect(simpleHashMap.get("1"), "11");

    // simpleHashMap.put("three", 4);
    // expect(simpleHashMap.get("three"), 4);
  });
}
