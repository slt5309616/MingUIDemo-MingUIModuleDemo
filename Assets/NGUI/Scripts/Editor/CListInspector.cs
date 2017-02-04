using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor {
    [CustomEditor(typeof(CList))]
    internal class CListInspector : UISpriteInspector {
        protected override void DrawCustomProperties() {
            NGUIEditorTools.DrawProperty("Content", serializedObject, "Content");
            NGUIEditorTools.DrawProperty("Overlay", serializedObject, "Overlay");
            NGUIEditorTools.DrawProperty("spSelected", serializedObject, "spSelected");
            NGUIEditorTools.DrawProperty("ItemRender", serializedObject, "ItemRender");
            NGUIEditorTools.DrawProperty("Bar", serializedObject, "Bar");
            NGUIEditorTools.DrawProperty("Recycle", serializedObject, "Recycle");
            NGUIEditorTools.DrawProperty("PaddingLeft", serializedObject, "PaddingLeft");
            NGUIEditorTools.DrawProperty("PaddingTop", serializedObject, "PaddingTop");
            NGUIEditorTools.DrawProperty("PaddingBottom", serializedObject, "PaddingBottom");
            NGUIEditorTools.DrawProperty("ColNum", serializedObject, "ColNum");
            base.DrawCustomProperties();
        }
    }
}