using System.Collections.Generic;

public class SixWorldMgr  {
    
    public List<int> indexList;

    private static SixWorldMgr instance;
    private SixWorldVO _data;
    public SixWorldVO data {
        get {
            return _data;
        }
        set {
            _data = value;
        }
    }
    public static SixWorldMgr getInstance() {
        if (instance==null) {
            instance = new SixWorldMgr();
        }
        return instance;
    }

    private SixWorldMgr() {
        indexList = null;
    }

    public void OnSixWorldInfo(SixWorldVO vo) {
        _data = vo;
        if (indexList==null) {
            indexList = new List<int>();
            for (int i = 0; i < _data.imageNum; i++) {
                indexList.Add(i);
            }
        }
    }
}
