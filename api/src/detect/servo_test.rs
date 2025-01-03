use html5ever::{parse_document, tendril::TendrilSink};
use markup5ever_rcdom::{Handle, NodeData, RcDom};
use servo::{
    media_queries::MediaList,
    servo_url::ServoUrl,
    style::context::QuirksMode,
    style::dom::{NodeInfo, TElement, TNode},
    style::properties::{
        ComputedValues, LonghandId, PropertyDeclaration, PropertyDeclarationBlock,
    },
    style::stylesheets::{Stylesheet, StylesheetInDocument},
    style::traversal::RecalcStyle,
};
use std::default::Default;

// Custom DOM node implementation for Servo's style system
struct StyleNode {
    node: Handle,
    parent: Option<Handle>,
    children: Vec<Handle>,
}

impl TNode for StyleNode {
    type ConcreteNode = Self;

    fn parent_node(&self) -> Option<Self> {
        self.parent.map(|p| StyleNode {
            node: p,
            parent: None, // We'll compute this when needed
            children: vec![],
        })
    }

    fn first_child(&self) -> Option<Self> {
        self.children.first().map(|c| StyleNode {
            node: c.clone(),
            parent: Some(self.node.clone()),
            children: vec![],
        })
    }

    fn last_child(&self) -> Option<Self> {
        self.children.last().map(|c| StyleNode {
            node: c.clone(),
            parent: Some(self.node.clone()),
            children: vec![],
        })
    }

    fn prev_sibling(&self) -> Option<Self> {
        // Implementation would need to traverse parent's children
        None
    }

    fn next_sibling(&self) -> Option<Self> {
        // Implementation would need to traverse parent's children
        None
    }

    fn owner_doc(&self) -> Self {
        // Return document node
        StyleNode {
            node: self.node.clone(),
            parent: None,
            children: vec![],
        }
    }
}

impl TElement for StyleNode {
    fn style_attribute(&self) -> Option<&PropertyDeclarationBlock> {
        None // For now, we're not handling inline styles
    }

    fn attr_matches(
        &self,
        _namespace: &ns!(()),
        _local_name: &LocalName,
        _operation: &AttrSelectorOperation,
    ) -> bool {
        false // Simplified attribute matching
    }

    fn imported_part(&self, _name: &LocalName) -> Option<LocalName> {
        None
    }

    fn exported_part(&self, _name: &LocalName) -> Option<LocalName> {
        None
    }

    fn is_part(&self, _name: &LocalName) -> bool {
        false
    }

    fn match_non_ts_pseudo_class(
        &self,
        _pc: NonTSPseudoClass,
        _context: &mut MatchingContext,
    ) -> bool {
        false
    }
}

pub struct StyleComputer {
    document: RcDom,
    computed_styles: HashMap<Handle, Arc<ComputedValues>>,
}

impl StyleComputer {
    pub fn new(html: &str) -> Result<Self, Box<dyn Error>> {
        let dom = parse_document(RcDom::default(), Default::default())
            .from_utf8()
            .read_from(&mut html.as_bytes())?;

        Ok(StyleComputer {
            document: dom,
            computed_styles: HashMap::new(),
        })
    }

    pub fn compute_styles(&mut self) -> Result<(), Box<dyn Error>> {
        let url = ServoUrl::parse("about:blank")?;
        let quirks_mode = QuirksMode::NoQuirks;

        // Create style context
        let mut context = StyleContext::new(url.clone(), quirks_mode, MediaList::empty(), None);

        // Process the document
        self.process_node(self.document.document.clone(), &mut context)?;

        Ok(())
    }

    fn process_node(
        &mut self,
        handle: Handle,
        context: &mut StyleContext,
    ) -> Result<(), Box<dyn Error>> {
        let node = StyleNode {
            node: handle.clone(),
            parent: None,
            children: vec![],
        };

        // Compute styles for this node
        if let Some(computed) = context.compute_style(&node) {
            self.computed_styles.insert(handle.clone(), computed);
        }

        // Process children
        if let NodeData::Element { .. } = handle.data {
            // for child in children.borrow().iter() {
            //     self.process_node(child.clone(), context)?;
            // }
        }

        Ok(())
    }

    pub fn get_computed_style(&self, node: &Handle) -> Option<ComputedStyle> {
        self.computed_styles
            .get(node)
            .map(|computed| ComputedStyle {
                font_family: computed.get_font_family().to_string(),
                font_size: computed.get_font_size().to_string(),
                line_height: computed.get_line_height().to_string(),
            })
    }
}

#[derive(Debug)]
pub struct ComputedStyle {
    pub font_family: String,
    pub font_size: String,
    pub line_height: String,
}

// Example usage
fn main() -> Result<(), Box<dyn Error>> {
    let html = r#"
        <html>
            <head>
                <style>
                    p { font-size: 18px; font-family: Arial; }
                    .special { line-height: 1.5; }
                </style>
            </head>
            <body>
                <p class="special">Hello World</p>
            </body>
        </html>
    "#;

    let mut computer = StyleComputer::new(html)?;
    computer.compute_styles()?;

    // Print computed styles for all elements
    let doc = &computer.document;
    traverse_and_print_styles(doc.document.clone(), &computer)?;

    Ok(())
}

fn traverse_and_print_styles(
    handle: Handle,
    computer: &StyleComputer,
) -> Result<(), Box<dyn Error>> {
    if let Some(style) = computer.get_computed_style(&handle) {
        println!("Node: {:?}", handle);
        println!("Computed styles: {:?}", style);
    }

    if let NodeData::Element { .. } = handle.data {
        // for child in children.borrow().iter() {
        //     traverse_and_print_styles(child.clone(), computer)?;
        // }
    }

    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test() {
        main();
    }
}
