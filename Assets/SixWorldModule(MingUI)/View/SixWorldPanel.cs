using UnityEngine;
using Assets.Scripts.Com.MingUI;
using System.Collections.Generic;
using Assets.Scripts.Com.Utils;
using MingUI.Com.Manager;
using System.Text;

public class SixWorldPanel  :MonoBehaviour{
    private CGrid grid;
    private UISprite starSprite;
    private CButton btnSwitch;
    private CButton resetBtn;
    private UILabel timeLabel;
    private UILabel numLabel;
    private UILabel lblContent;
    private float enlageScale;
    private int curIndex;
    private int newIndex;
    private float totalTime;
    private float leftTime;
    private int _currentRefreshTimes;
    private bool _isInSecondLoop;
    private float _normalScale = 1f;
    private Vector3 OffsetYAmount ;
    private Vector3 OffsetXAmount;
    private int imageNum;
    private Texture2D textureMouseNormal;
    private Texture2D textureMouseClick;
    private Texture2D textureMouseHover;
    private List<Transform> itemList;
    public enum Direction
    {
        Down,
        Up,
    }
    
    public enum Sorting
    {
        None,
        Alphabetic,
        Horizontal,
        Vertical,
        Custom,
    }
    private enum Mode{
        Selected,
        UnSelected,
    }
    /// <summary>
    /// 
    /// </summary>
    private int columns = 0;
    private Direction direction = Direction.Down;
    private Sorting sorting = Sorting.Horizontal;
    private UIWidget.Pivot pivot = UIWidget.Pivot.TopLeft;
    private UIWidget.Pivot cellAlignment = UIWidget.Pivot.TopLeft;
    private bool hideInactive = false;
    private Vector2 padding = new Vector2(15, 0);

    Color darkColor = new Color(0.3f, 0.3f, 0.3f);
    Color lightColor = new Color(1, 1, 1);
    ///////////////////////////////////////////
    private GameObject myPanel;
    private SixWorldMgr dataManager;
    public SixWorldPanel() {
        myPanel = Instantiate(Resources.Load("MingUI/Prefabs/TestPanel")) as GameObject;

        myPanel.transform.position = new Vector3(-314,179,0);

        Init();
    }
    public void Open() {
        myPanel.SetActive(true);
    }
	// Use this for initialization
	void Init () {
        /////////////////////////////////////////
        //SixWorldModule.getInstance();
        dataManager = SixWorldMgr.getInstance();
        var tempData = dataManager.data;
        grid = DisplayUtil.getChildObjByName(myPanel.transform, "Grid").GetComponent<CGrid>();
        starSprite=DisplayUtil.getChildObjByName(myPanel.transform, "StarSprite").GetComponent<UISprite>();
        btnSwitch = DisplayUtil.getChildObjByName(myPanel.transform, "SwitchButton").GetComponent<CButton>();
        resetBtn = DisplayUtil.getChildObjByName(myPanel.transform, "ResetButton").GetComponent<CButton>();
        timeLabel=DisplayUtil.getChildObjByName(myPanel.transform, "TimeLabel").GetComponent<UILabel>();
        numLabel = DisplayUtil.getChildObjByName(myPanel.transform, "NumLabel").GetComponent<UILabel>();
        lblContent = DisplayUtil.getChildObjByName(myPanel.transform, "lblContent").GetComponent<UILabel>();
        /////////////////////////////////////////
        leftTime = totalTime = tempData.refreshTimeInSeconds;
        _currentRefreshTimes = tempData.totalRefreshTimes = tempData.totalRefreshTimes > 0 ? tempData.totalRefreshTimes : 0;
        enlageScale = tempData.enlageScale;
        imageNum = tempData.imageNum;
        timeLabel.text = "";
        _isInSecondLoop = false;
        textureMouseHover = Resources.Load("MingUI/NewAtlas/UICommon/Mouse/click_over") as Texture2D;
        textureMouseClick = Resources.Load("MingUI/NewAtlas/UICommon/Mouse/click_down") as Texture2D;
        textureMouseNormal = Resources.Load("MingUI/NewAtlas/UICommon/Mouse/normal") as Texture2D;
        Cursor.SetCursor(textureMouseNormal, Vector2.zero, CursorMode.Auto);
        //////////////////////////////////////
        grid.itemRender = typeof(SixWorldRender);
        grid.SetDataProvider<int>(dataManager.indexList);
        btnSwitch.AddClick(OnSwitchBtnClicked);
        resetBtn.AddClick(OnResetBtnClicked);
        var left = DisplayUtil.getChildObjByName(lblContent.transform, "LinkLeft");
        var right = DisplayUtil.getChildObjByName(lblContent.transform, "LinkRight");
        UIEventListener.Get(left).onHover = OnLblContentHover;
        UIEventListener.Get(right).onHover = OnLblContentHover;
        UIEventListener.Get(left).onPress = OnLblContentPress;
        UIEventListener.Get(right).onPress = OnLblContentPress;
        //////////////////////////////////////
        for (int i = 0; i < imageNum;i++ )
        {
            var component = DisplayUtil.GetChildByName(grid.transform, "Item" + i);
            ChangeColor(component, darkColor);
        }
        curIndex = -1;
        newIndex = tempData.defaultIndex;

        OffsetYAmount = new Vector3(0, grid.transform.GetChild(0).GetComponentInChildren<Image>().height*(enlageScale-1)*0.5f);
        OffsetXAmount = new Vector3(grid.transform.GetChild(0).GetComponentInChildren<Image>().width * (enlageScale - 1) * 0.5f,0);
        UILoopManager.AddToSecond(myPanel, OnTimeCountDown);
        UILoopManager.AddToFrame(myPanel, Loop);
	}
	
	// Update is called once per frame
	private void Loop () {
        if (curIndex!=newIndex)
	    {
            var component = grid.transform.GetChild(newIndex);
            if (component == null)
            {
                Debug.Log("Getting Grid component failed");
            }
            ChangeItem(component, Mode.Selected);
            setStarSprite(newIndex);

            if (curIndex>=0)
            {
                component = grid.transform.GetChild(curIndex); ;
                if (component == null)
                {
                    Debug.Log("Getting Grid component failed");
                }
                ChangeItem(component, Mode.UnSelected);
            }
            



            RepositionVariableSize(GetChildList(grid.transform));
            RepositionY();
            //grid.Reposition();

            //updateFinishied, switch Index;
            curIndex = newIndex;
	    }

        if (_currentRefreshTimes<= 0)
        {
            btnSwitch.isEnabled = false;
        }
        if (_currentRefreshTimes > 0)
        {
            btnSwitch.isEnabled = true;
        }
        numLabel.text = _currentRefreshTimes.ToString();
        timeLabel.text = ((int)(leftTime / (60 * 60))).ToString() + ":"
                    + ((int)((leftTime / 60) % 60)).ToString() + ":"
                    + ((int)(leftTime % 60)).ToString();

        if (!_isInSecondLoop && _currentRefreshTimes != dataManager.data.totalRefreshTimes)
        {
            UILoopManager.AddToSecond(myPanel, OnTimeCountDown);
            _isInSecondLoop = true;
        }
        if (_currentRefreshTimes == dataManager.data.totalRefreshTimes)
        {
            timeLabel.text = "";
            UILoopManager.RemoveFromSecond(myPanel);
            _isInSecondLoop = false;
        }
	}
    private void ChangeItem(Transform trans, Mode mode) {
        float scale;
        Color color;
        var tempComponent = trans.GetComponent<UIWidget>();
        switch (mode) {
            case Mode.Selected:
                scale = enlageScale;
                color = lightColor;
                break;
            case Mode.UnSelected:
                scale = _normalScale;
                color = darkColor;
                break;
            default:
                scale = _normalScale;
                color = darkColor;
                break;
        }
        trans.localScale = new Vector3(scale, scale);

        ChangeColor(trans, color);
    }
    private void ChangeColor(Transform trans, Color color) {
        trans.GetComponentInChildren<Image>().color = color;
        trans.GetComponentInChildren<UISprite>().color = color;
    }
    public void OnSwitchBtnClicked(GameObject go)
    {
        newIndex++;
        if (newIndex >= imageNum)
        {
            newIndex -= imageNum;
        }
        _currentRefreshTimes--;
    }
    public  void OnResetBtnClicked(GameObject go)
    {
        newIndex = dataManager.data.defaultIndex ;
    }
    public void OnLblContentHover(GameObject go, bool state) {
        if (state){
            Cursor.SetCursor(textureMouseHover, Vector2.zero, CursorMode.Auto);
        } else {
            Cursor.SetCursor(textureMouseNormal, Vector2.zero, CursorMode.Auto);
        }
        switch (go.name) {
            case "LinkLeft":
                //Debug.Log("LinkLeft Hover" );
                break;
            case "LinkRight":
                //Debug.Log("LinkRight Hover");
                break;
            default:
                break;
        }
    }
    public void OnLblContentPress(GameObject go, bool state) {
        if (state){
            Cursor.SetCursor(textureMouseClick, Vector2.zero, CursorMode.Auto);
        } else {
            Cursor.SetCursor(textureMouseNormal, Vector2.zero, CursorMode.Auto);
            switch (go.name) {
                case "LinkLeft":
                    Debug.Log("LinkLeft Press" + getStrFromLabel(lblContent,0));
                    break;
                case "LinkRight":
                    Debug.Log("LinkRight Press" + getStrFromLabel(lblContent,1));
                    break;
                default:
                    break;
            }
        }
    }
    private void setStarSprite(int index)
    {
        starSprite.spriteName = (newIndex+1).ToString();
        var tempSprite = starSprite.atlas.GetSprite(starSprite.spriteName);
        starSprite.width = tempSprite.width;
        starSprite.height = tempSprite.height;
    }
    public List<Transform> GetChildList(Transform transform)
    {
        Transform myTrans = transform;
        List<Transform> list = new List<Transform>();

        for (int i = 0; i < myTrans.childCount; ++i)
        {
            Transform t = myTrans.GetChild(i);
            if (!hideInactive || (t && NGUITools.GetActive(t.gameObject)))
                list.Add(t);
        }

        // Sort the list using the desired sorting logic
        if (sorting != Sorting.None)
        {
            if (sorting == Sorting.Alphabetic) list.Sort(UIGrid.SortByName);
            else if (sorting == Sorting.Horizontal) list.Sort(UIGrid.SortHorizontal);
            else if (sorting == Sorting.Vertical) list.Sort(UIGrid.SortVertical);
        }
        return list;
    }
    private void RepositionVariableSize(List<Transform> children)
    {
        int columns = imageNum;
        float xOffset = 0;
        float yOffset = 0;

        int cols = columns > 0 ? children.Count / columns + 1 : 1;
        int rows = columns > 0 ? columns : children.Count;

        Bounds[,] bounds = new Bounds[cols, rows];
        Bounds[] boundsRows = new Bounds[rows];
        Bounds[] boundsCols = new Bounds[cols];

        int x = 0;
        int y = 0;

        for (int i = 0, imax = children.Count; i < imax; ++i)
        {
            Transform t = children[i];
            Bounds b = NGUIMath.CalculateRelativeWidgetBounds(t, !hideInactive);

            Vector3 scale = t.localScale;
            b.min = Vector3.Scale(b.min, scale);
            b.max = Vector3.Scale(b.max, scale);
            bounds[y, x] = b;

            boundsRows[x].Encapsulate(b);
            boundsCols[y].Encapsulate(b);

            if (++x >= columns && columns > 0)
            {
                x = 0;
                ++y;
            }
        }                                                       

        x = 0;
        y = 0;

        Vector2 po = NGUIMath.GetPivotOffset(cellAlignment);

        for (int i = 0, imax = children.Count; i < imax; ++i)
        {
            Transform t = children[i];
            Bounds b = bounds[y, x];
            Bounds br = boundsRows[x];
            Bounds bc = boundsCols[y];

            Vector3 pos = t.localPosition;
            pos.x = xOffset + b.extents.x - b.center.x;
            pos.x -= Mathf.Lerp(0f, b.max.x - b.min.x - br.max.x + br.min.x, po.x) - padding.x;

            if (direction == Direction.Down)
            {
                pos.y = -yOffset - b.extents.y - b.center.y;
                pos.y += Mathf.Lerp(b.max.y - b.min.y - bc.max.y + bc.min.y, 0f, po.y) - padding.y;
            }
            else
            {
                pos.y = yOffset + b.extents.y - b.center.y;
                pos.y -= Mathf.Lerp(0f, b.max.y - b.min.y - bc.max.y + bc.min.y, po.y) - padding.y;
            }

            xOffset += br.size.x + padding.x * 2f;

            t.localPosition = pos + new Vector3(i * grid.HGap,0);

            if (++x >= columns && columns > 0)
            {
                x = 0;
                ++y;

                xOffset = 0f;
                yOffset += bc.size.y + padding.y * 2f;
            }
        }

        // Apply the origin offset
        if (pivot != UIWidget.Pivot.TopLeft)
        {
            po = NGUIMath.GetPivotOffset(pivot);

            float fx, fy;

            Bounds b = NGUIMath.CalculateRelativeWidgetBounds(transform);

            fx = Mathf.Lerp(0f, b.size.x, po.x);
            fy = Mathf.Lerp(-b.size.y, 0f, po.y);

            Transform myTrans = transform;

            for (int i = 0; i < myTrans.childCount; ++i)
            {
                Transform t = myTrans.GetChild(i);
                SpringPosition sp = t.GetComponent<SpringPosition>();

                if (sp != null)
                {
                    sp.target.x -= fx;
                    sp.target.y -= fy;
                }
                else
                {
                    Vector3 pos = t.localPosition;
                    pos.x -= fx;
                    pos.y -= fy;
                    t.localPosition = pos;
                }
            }
        }
    }
    private void RepositionY() {
        var trans = grid.transform.GetChild(newIndex);
        trans.localPosition += OffsetYAmount;
    }
    private void OnTimeCountDown()
    {
        leftTime--;

        if (leftTime<0)
        {
            _currentRefreshTimes++;
            leftTime = totalTime;
        }
    }

    private string getStrFromLabel(UILabel lbl,int index) {
       
        StringBuilder str = new StringBuilder(lbl.text);
        if (index ==0){
            str.Remove(0, lbl.text.IndexOf("]") + 1);
            return str.ToString(0, lbl.text.IndexOf("[")-1);
        } 
        if (index ==1){
            str.Remove(lbl.text.LastIndexOf("["), lbl.text.Length - lbl.text.LastIndexOf("]"));
            return str.ToString(lbl.text.LastIndexOf("]")+1, lbl.text.Length - lbl.text.LastIndexOf("]")-1);
        }
        return null;
    }
}
