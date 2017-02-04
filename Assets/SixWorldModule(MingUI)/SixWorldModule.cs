using System;

public class SixWorldModule  {
    private static SixWorldModule instance;
    private SixWorldPanel panel;
    private SixWorldMgr dataManager;
    public Action<SixWorldVO> onTotalNumChange;
    public static SixWorldModule getInstance() {
        if (instance ==null){
            instance = new SixWorldModule();
        }
        return instance;
    }

    private SixWorldModule() {
        dataManager = SixWorldMgr.getInstance();
        InitListener();
        FakeMassage();
    }
    private void InitListener() {
        onTotalNumChange = dataManager.OnSixWorldInfo;
    }
    private void FakeMassage() {
        var vo = new SixWorldVO();
        vo.imageNum = 5;
        vo.refreshTimeInSeconds = 10f;
        vo.totalRefreshTimes = 10;
        vo.defaultIndex = 1;
        vo.enlageScale = 1.3f;
        onTotalNumChange.Invoke(vo);
        OpenSixWorldPanel();
    }
    public void OpenSixWorldPanel() {
        if (panel ==null) {
            panel = new SixWorldPanel();
        }
        panel.Open();
    }
}
