using UnityEngine;
using System.Collections;
using Assets.Scripts.Com.MingUI;
using Assets.Scripts.Com.Utils;
using System.Collections.Generic;
using Mono.Cecil;
using Assets.Scripts.Com.Managers;
using System.Reflection;

public class PanelCtrl : MonoBehaviour {
    public UILabel powerLabel;
    public CScrollBar powerLabelScrollBar;
    public CButton petStateBtn;
    public CNumStepper petSpriteCtrl;
    public CTabBar tabBar;
    public int branchNum;
    public int leafNum;
    public int comboxItemNum;
    public float maxValue;
    public CTree tree;
    public GameObject branchRender;
    public GameObject leafRender;
    public int listItemNum;
    public CList list;
    public CCombobox combox;
    public UILabel textLabel;
    public GameObject popUpView;
    public CButton showPopUpViewBtn;
    public UIWidget iconContainer;

    private System.Type _renderType;

    private Image _petTexture;
    private string[] _petStateList ={"休","出" };
    private string[] _petTextureName = { "suitIcon1", "suitIcon2", "suitIcon3" };
    private Transform _baseToolTip;
    //private bool _isShowToolTip;
    private List<CTreeNode> _branchList;
    private List<string> _listData1 = new List<string>();
    private List<string> _listData2 = new List<string>();
    private List<object> _comboxData = new List<object>();
    enum PetState
    {
        PET_RESET,
        PET_FIGHT
    };
    private PetState _petState;  //true

	// Use this for initialization
    void Start() {

        powerLabelScrollBar.OnChangeFun += OnPowerLabelValueChange;

        powerLabel.text = ((int)maxValue).ToString();
        petStateBtn = DisplayUtil.GetChildByName(this.transform, "btnState").GetComponent<CButton>();
        _petTexture = DisplayUtil.GetChildByName(this.transform, "imgHead").GetComponent<Image>();
        if (petStateBtn != null) {
            petStateBtn.AddClick(OnStateBtnClicked);
        } else {
            print("petStateBtn is null");
        }
        _petState = PetState.PET_RESET;

        petSpriteCtrl.OnChange(OnNumIndexChange);
        petStateBtn.AddRollOver(OnRollOverStateBtn);
        petStateBtn.AddRollOut(OnRollOutStateBtn);

        _baseToolTip = this.transform.Find("MyToolTip");
        //_isShowToolTip = false;
        var tempAssembly = Assembly.LoadFrom("Assets/Plugins/MingUI.dll");
        _renderType = tempAssembly.GetType("Assets.Scripts.Com.MingUI.CMyItemRender");
        //InitTree();
        //var tempAssembly = Assembly.LoadFrom("Assets/Plugins/MingUI.dll");

        //print(tempAssembly.FullName);
        //print(tempAssembly.GetType("Assets.Scripts.Com.MingUI.CTreeNode"));

        //ToolTipManager.RegisterToolTip(0,System.Type.GetType(""));
        //petStateBtn.ToolTip = "xxxxx";
        InitList();
        InitComboBox();
        tabBar.OnChange = OnTabBarIndexChange;
        list.OnItemDoubleClick += OnListItemDoubleClicked;
        var closeBtn = DisplayUtil.GetChildByName(popUpView.transform, "BtnClose").GetComponent<CButton>();
        if (closeBtn != null) {
            closeBtn.AddClick(OnClosePopUpBtnClicked);
        } else {
            print("closeBtn null");
        }
        showPopUpViewBtn.AddClick(OnShowPopUpViewBtnClicked);

        var iconCtrlBtn = DisplayUtil.GetChildByName(iconContainer.transform, "Button").GetComponent<CButton>();
        if (iconCtrlBtn != null) {
            iconCtrlBtn.AddClick(OnIconCtrlBtnClicked);
        } else {
            print("iconCtrlBtn null");
        }
    }
    void Update()
    {
        petStateBtn.GetComponentInChildren<UILabel>().text = _petStateList[(int)_petState];
        //if (_isShowToolTip)
        //{
        //    _baseToolTip.position = UICamera.lastEventPosition;
        //}
    }
    public void OnPowerLabelValueChange(GameObject go, float delta)
    {
        powerLabel.text = ((int)(maxValue * (1 - delta))).ToString();
    }
    public void OnStateBtnClicked(GameObject go)
    {
        if (_petState==PetState.PET_RESET)
        {
            _petState = PetState.PET_FIGHT;
        }
        else
	    {
            _petState = PetState.PET_RESET;
    	}
    }
    public void OnNumIndexChange()
    {
        var tempTexture =Resources.Load("MingUI/NewAtlas/Module/" + _petTextureName[(int)petSpriteCtrl.Value - 1]) as Texture2D;
        if (tempTexture!=null)
        {
            _petTexture.mainTexture = tempTexture;
        }
        else
        {
            print("tempTexture in  OnNumIndexChange is null");
        }
    }
    public void OnRollOverStateBtn(GameObject go)
    {
        //_baseToolTip.gameObject.SetActive(true);
        //_isShowToolTip = true;

    }
    public void OnRollOutStateBtn(GameObject go)
    {
        if (_baseToolTip.gameObject.activeInHierarchy)
        {
            _baseToolTip.gameObject.SetActive(false);
        }
        //_isShowToolTip = false;
    }
    private void InitTree()
    {
        if (_branchList==null)
        {
            _branchList =new List<CTreeNode>();
        }
        InitBranchs();
        //var tempAssembly = Assembly.LoadFrom("Assets/Plugins/MingUI.dll");
        //var type = tempAssembly.GetType("Assets.Scripts.Com.MingUI.CTreeNode");

        //CTreeNode branch = new CTreeNode();
        //branch.name = "branch";
        //branch.SetGO(branchRender);
        //branch.type = CTreeNode.NodeType.Branch;
        //CTreeNode leaf = new CTreeNode();
        //leaf.name = "leaf";
        //leaf.SetGO(leafRender);
        //leaf.type = CTreeNode.NodeType.Leaf;

        //CItemRender render = new CItemRender("render");
        //tree.branchRender = render.GetType();
        //tree.leafRender = render.GetType();

        print(branchRender.GetType().ToString());
        print(leafRender.GetType().ToString());
        tree.SetDataProvider<CTreeNode>(_branchList);

    }
    private void InitBranchs()
    {
        for (int i = 0; i < branchNum; i++)
        {
            CTreeNode branch = new CTreeNode();
            branch.name = "Branch" + i.ToString();
            branch.data = new CTreeNodeData();
            branch.data.child = new List<CTreeNodeData>();
            _branchList.Add(branch);
            InitLeafs(branch);
        }
    }
    private void InitLeafs(CTreeNode branch)
    {
        for (int i = 0; i < leafNum; i++)
        {
            CTreeNodeData child = new CTreeNodeData();
            child.parent = branch.data;
            branch.data.child.Add(child);
        }
    }
    private void InitList()
    {
        
        for (int i = 0; i < listItemNum; i++)
        {
            _listData1.Add("Test1---"+i);
        }
        for (int i = 0; i < listItemNum; i++)
        {
            _listData2.Add("Test2---" + i);
        }
        CMyItemRender.widgetHeight = 40;
        CMyItemRender.widgetWidth = 200;


        list.itemRender = _renderType;
        list.SetDataProvider<string>(_listData1);
    }
    private void InitComboBox()
    {
        for (int i = 0; i < comboxItemNum; i++)
        {
            _comboxData.Add("combox-"+i);
        }

        CMyItemRender.widgetHeight = 20;
        CMyItemRender.widgetWidth = 129;
        combox.List.itemRender = _renderType;
        combox.DataProvider = _comboxData;
    }
    public void OnTabBarIndexChange(int index)
    {
        switch (index)
        {
            case 0:
                list.SetDataProvider<string>(_listData1);
                list.ScrollToIndex(0);
                break;
            case 1:
                list.SetDataProvider<string>(_listData2);
                list.ScrollToIndex(0);
                break;
        }
    }
    public void OnListItemDoubleClicked(CItemRender selectItem)
    {
        textLabel.text = selectItem.Data.ToString();
    }
    public void OnClosePopUpBtnClicked(GameObject go)
    {
         if (popUpView.activeInHierarchy)
         {
             popUpView.SetActive(false);
             popUpView.transform.localPosition = new Vector3(265.8f, -280f, 0f);
         }
    }
    public void OnShowPopUpViewBtnClicked(GameObject go)
    {
        if (!popUpView.activeInHierarchy)
        {
            popUpView.SetActive(true);
        }
        else
        {
            return;
        }
        Hashtable args = new Hashtable();
        args.Add("easeType", iTween.EaseType.easeInQuad);
        args.Add("time", 2f);
        args.Add("delay", 0.1f);
        args.Add("loopType", "none");
        args.Add("x", 265.8f);
        args.Add("y", -112.8f);
        args.Add("z", 0f);

        iTween.MoveTo(popUpView, args);
    }
    public void OnIconCtrlBtnClicked(GameObject go)
    {
        UIPanel content = DisplayUtil.GetChildByName(iconContainer.transform, "Content").GetComponent<UIPanel>();
        for (int i = 0;i< content.transform.childCount; i++)
        {
            var tempWidget = content.transform.GetChild(i).GetComponent<UIWidget>();
            Hashtable args = new Hashtable();
            args.Add("easeType", iTween.EaseType.easeInQuad);
            args.Add("time", 0.5f);
            args.Add("delay", ((float)i/10f+0.1f));
            args.Add("loopType", "none");
            args.Add("amount", new Vector3(50f * i, 0, 0));
            iTween.MoveBy(tempWidget.gameObject, args);
        }
    }

}
