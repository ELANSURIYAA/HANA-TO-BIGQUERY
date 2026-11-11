# File Relationships Table

| Source File | Target File | Dependency Type | Score | Reason |
|---|---|---|---|---|
| xml_acc_FLASH_SALES_VT_CAR | xml_acc_FLASH_SALES_VT_CAR (Self — Internal Node Dependency) | Calculation View Dependency | 90 | The Calculation View XML defines multiple internal logical nodes: a Filter node (with input parameters IP_UPD_TIMESTAMP_FROM and IP_UPD_TIMESTAMP_TO), a Projection node, and an Aggregation node. These nodes are chained internally within the single artifact. The data source referenced is an internal data foundation node feeding into the projection and aggregation layers. All logic is self-contained within this single artifact file. No external artifact dependency is evidenced in the supplied file set. |
