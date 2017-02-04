using Assets.Scripts.Com.MingUI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor {
        [CustomEditor(typeof(CTileList))]
    class CTileListInspector : UISpriteInspector {
        protected override void DrawCustomProperties() {
            NGUIEditorTools.DrawProperty("Content", serializedObject, "Content");
            NGUIEditorTools.DrawProperty("Overlay", serializedObject, "Overlay");
            NGUIEditorTools.DrawProperty("spSelected", serializedObject, "spSelected");
            NGUIEditorTools.DrawProperty("ItemRender", serializedObject, "ItemRender");
            NGUIEditorTools.DrawProperty("Bar", serializedObject, "Bar");
            NGUIEditorTools.DrawProperty("Recycle", serializedObject, "Recycle");
            NGUIEditorTools.DrawProperty("PaddingLeft", serializedObject, "PaddingLeft");
            NGUIEditorTools.DrawProperty("PaddingTop", serializedObject, "PaddingTop");
            NGUIEditorTools.DrawProperty("ColNum", serializedObject, "ColNum");
            base.DrawCustomProperties();
        }
    }
}
