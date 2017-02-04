using UnityEngine;
using Assets.Scripts.Com.MingUI;
using Assets.Scripts.Com.UI;

public class SixWorldRender : CItemRender {
    protected Image bgImage;
    protected BoxCollider box;
    protected new UIWidget widget;
    private UISprite _starImage;
    private int _index;
    new protected  object _data;

    public override object Data
    {
        get
        {
            return _index;
        }
        set
        {
            _index = (int)value;
            _starImage.spriteName = (_index + 1).ToString();
        }
    }
    public SixWorldRender()
    {
        SetGO(new GameObject());
        widget = AddComponent<UIWidget>();
        widget.pivot = UIWidget.Pivot.TopLeft;
        widget.autoResizeBoxCollider = true;

        box = AddComponent<BoxCollider>();

        bgImage = UICreater.CreateImage(0, 0, tran);
        var tempTexture = Resources.Load("MingUI/Textures/TestTexture/5s") as Texture2D;
        bgImage.mainTexture = tempTexture;
        bgImage.pivot = UIWidget.Pivot.TopLeft;
        bgImage.type = UIBasicSprite.Type.Simple;
        bgImage.SetDimensions(tempTexture.width,tempTexture.height);
        widget.SetDimensions(tempTexture.width, tempTexture.height);

        //default
        _starImage = UICreater.CreateSprite("MingUI/Textures/TestTexture/6Atlas.prefab", "1", 0, 0,tran,0,0,2);
        _starImage.pivot = UIWidget.Pivot.TopLeft;
        _starImage.type = UIBasicSprite.Type.Simple;
        _starImage.transform.localPosition = new Vector3(42,0);
        _starImage.atlas = Resources.Load("MingUI/Textures/TestTexture/6Atlas", typeof(UIAtlas)) as UIAtlas;
        _starImage.spriteName = "1";
    }

	// Use this for initialization

    public override void Act(params object[] arg)
    {
        base.Act(arg);
    }
	// Update is called once per frame
}
